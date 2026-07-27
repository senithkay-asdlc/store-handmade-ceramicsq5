# Design — Handmade Ceramics Online Store

## 1. Overview

The system is a small e-commerce platform for a handmade-ceramics business.
It has two browser-facing surfaces backed by one API service: a public
storefront where shoppers browse the catalog, manage a cart, and check out
with real payment processing, and a separate admin console where the store
owner manages the product catalog, inventory, and orders. Both surfaces
authenticate through the platform's Thunder identity provider — shoppers
optionally (guest checkout remains available), the store admin always — and
the API service processes payment through Stripe.

## 2. Components

- **storefront-webapp** (`web-application`) — the public shopper-facing
storefront: catalog browsing/search, cart, checkout, optional account
sign-in and order history. Distinct user base and lifecycle from the admin
console.
- **admin-webapp** (`web-application`) — the store owner's administrative
console: product/inventory management and order management. Kept as a
separate deployable from the storefront because it serves a different user
(the store admin, always signed in) with different screens and a different
release cadence than the public shopping experience.
- **ceramics-api** (`service`) — the single backend service owning the
product catalog, cart, checkout/order processing (including Stripe payment
and atomic stock decrement), and account data. One service because every
capability shares the same core entities (products, orders) and there is no
requirement forcing a different runtime, scaling profile, or technology.

## 3. Capabilities

### storefront-webapp

- Browse/search/filter the product catalog; view product detail pages,
including sold-out state (FR-1–FR-5).
- Manage a cart: add/remove/change quantity, subtotal, stock-aware quantity
caps, cart persistence for guest and signed-in shoppers (FR-6–FR-9).
- Checkout as guest or signed-in shopper: shipping address, order total
(subtotal + shipping + tax), Stripe payment, stock re-validation, order
confirmation, and failure handling (FR-10–FR-16).
- Optional shopper registration/sign-in, order history, and saved shipping
address (FR-17–FR-19).

### admin-webapp

- Admin sign-in, separate from the shopper-facing site (FR-20).
- Create/edit/publish/unpublish/delete products, including price, category,
photos, and stock count (FR-21).
- Direct stock adjustment (restock/correction) (FR-22).
- View all orders, order detail, and update fulfillment status (FR-23).
- View basic sales/order-volume reporting (FR-24).

### ceramics-api

- Product catalog CRUD + publish state + stock count, category/keyword/price
search (FR-1–FR-5, FR-21, FR-22).
- Cart storage and validation keyed to a guest identifier or signed-in
shopper (FR-6–FR-9).
- Checkout orchestration: address capture, total computation, Stripe payment
intent/charge, atomic stock decrement tied to order creation, order
confirmation, and failure/rollback handling (FR-10–FR-16, NFR-3, NFR-7).
- Account data: registration/profile, saved address, order history
(FR-17–FR-19).
- Order management and reporting for the admin console (FR-23, FR-24).
- Role resolution (shopper vs. store admin) via Thunder groups (NFR-2).

## 4. Data model

- **Product** — id, name, description, category, price, photoUrls\[\],
stockCount, published (bool), createdAt/updatedAt.
- **CartItem** — cartId (guest id or shopper id), productId, quantity,
unitPriceSnapshot.
- **Order** — id, orderNumber, customer (guest contact or shopperId),
shippingAddress, lineItems (productId, name, unitPrice, quantity — snapshot
at purchase time per NFR-7), subtotal, shipping, tax, total, paymentStatus,
fulfillmentStatus (pending/shipped/delivered/cancelled), stripePaymentId,
createdAt.
- **Shopper (account)** — id, email, passwordHash, savedAddress, createdAt.
- **Address** (embedded in Order and Shopper) — name, line1/line2, city,
state/region, postalCode, country.

## 5. Roles &amp; access

## 6. Interactions

- `storefront-webapp -> ceramics-api` — catalog, cart, checkout, account, and
order-history calls.
- `storefront-webapp -> store-auth` — OIDC sign-in for shoppers who choose to
register/sign in (guest checkout bypasses this).
- `admin-webapp -> ceramics-api` — product, inventory, and order-management
calls.
- `admin-webapp -> store-auth` — OIDC sign-in for the store admin (always
required to reach the admin console).
- `ceramics-api -> store-auth` — the platform gateway validates every signed-
in caller's JWT against Thunder and injects identity headers; ceramics-api
reads `X-User-Id`/`X-User-Groups`, never issues tokens itself.
- `ceramics-api -> stripe` — payment processing (charge creation) during
checkout.

## 7. Data flow

1. **Browse &amp; add to cart** — a shopper (guest or signed-in) loads
 storefront-webapp, which calls `ceramics-api` to list/search published
 products; adding an in-stock item calls `ceramics-api` to create/update a
 cart line, capped at the product's current stock.
2. **Checkout** — the shopper submits shipping details and payment;
 storefront-webapp calls `ceramics-api`, which re-validates stock for every
 cart line, computes the order total, creates a Stripe charge, and — only
 on successful payment — atomically decrements stock and creates the order
 record; on failure the cart and stock are left untouched and an error is
 returned.
3. **Order confirmation &amp; history** — on success the shopper sees an order
 confirmation with an order number; if signed in, the order is retrievable
 later from their order-history view.
4. **Admin catalog management** — the store admin signs in to admin-webapp,
 which calls `ceramics-api` to create/edit products and stock counts; new
 or updated products immediately affect what storefront-webapp shows as
 available/sold-out.
5. **Admin order fulfillment** — the store admin views incoming orders in
 admin-webapp and updates fulfillment status through `ceramics-api` as
 items are shipped/delivered/cancelled.