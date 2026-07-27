# Requirements Specification — Handmade Ceramics Online Store

## 1. Overview

An online store for a handmade ceramics business. The store presents a
public product catalog, a shopping cart, and a checkout flow with real
payment processing. The store owner (artisan/admin) has an administrative
interface to manage products, inventory, and orders. Shoppers may check out
as guests or create an optional account to track their order history.

### 1.1 Goals

- Let shoppers browse and search a catalog of handmade ceramic pieces.
- Let shoppers add items to a cart and complete a purchase with a real
payment gateway.
- Let shoppers optionally register/sign in to view their past orders.
- Let the store owner manage the product catalog, stock levels, and
incoming orders through an admin interface.
- Accurately track inventory so that one-of-a-kind or limited-stock pieces
cannot be oversold.

### 1.2 Out of Scope

- Multi-vendor marketplace features (multiple independent sellers,
vendor payouts, vendor onboarding).
- Product variants (e.g., size/color options tied to one listing) — each
catalog listing is a single, simple SKU with its own price and stock
count.
- Shipping-carrier integration/label printing (shipping cost and address
capture are in scope; carrier API integration is not).
- Marketing features such as coupons, discounts, or loyalty programs.
- Multi-currency support.

## 2. User Roles

## 3. Functional Requirements

### 3.1 Product Catalog

- FR-1: The system shall display a public catalog of ceramic products,
each with a name, description, photo(s), price, and available stock
count.
- FR-2: The system shall let shoppers browse the catalog by category
(e.g., mugs, bowls, vases, plates) and view a single product's detail
page.
- FR-3: The system shall let shoppers search products by keyword (name/
description) and filter by category and price range.
- FR-4: The system shall mark a product as "sold out" and prevent it from
being added to a cart once its stock count reaches zero.
- FR-5: Each product is a single, simple SKU (no variants); stock is
tracked per product, and may be as low as 1 for a unique, one-of-a-kind
piece.

### 3.2 Cart

- FR-6: The system shall let a shopper add a product to a cart, remove a
product, and change the quantity of a cart line, subject to available
stock.
- FR-7: The system shall persist the cart for a guest shopper for the
duration of their session/browser (e.g., via a session or local
identifier) and persist it across sessions for a signed-in shopper.
- FR-8: The system shall prevent the cart quantity for a product from
exceeding that product's currently available stock, and shall show a
clear message when requested quantity is unavailable.
- FR-9: The system shall show a running subtotal for the cart's contents.

### 3.3 Checkout

- FR-10: The system shall let a shopper check out either as a guest
(providing name, email, shipping address, and payment details for that
order only) or, if signed in, using saved profile/address information.
- FR-11: The system shall collect a shipping address and compute an order
total consisting of item subtotal, shipping cost, and applicable tax.
- FR-12: The system shall process payment for the order total through a
real payment gateway (e.g., Stripe) before the order is confirmed.
- FR-13: The system shall re-validate stock availability for every cart
line at checkout time and reject/adjust the order if an item has sold
out since it was added to the cart.
- FR-14: On successful payment, the system shall decrement stock for each
purchased product, create an order record, and show/send an order
confirmation (including an order number) to the shopper.
- FR-15: If payment fails or is declined, the system shall leave the cart
intact, not decrement stock, and show the shopper an actionable error
message so they may retry.
- FR-16: The system shall not store raw payment card data itself; card
data handling shall be delegated to the payment gateway (e.g., via
tokenization/hosted fields), consistent with PCI scope reduction.

### 3.4 Accounts

- FR-17: The system shall let a visitor register for an account (email +
password) and sign in/out; guest checkout shall remain fully available
without registering.
- FR-18: A signed-in shopper shall be able to view a list of their past
orders and the detail/status of each order.
- FR-19: A signed-in shopper shall be able to save and reuse a shipping
address on future orders.

### 3.5 Admin (Store Owner)

- FR-20: The system shall let a store admin sign in to a separate admin
interface, distinct from the shopper-facing site.
- FR-21: The system shall let a store admin create, edit, publish/
unpublish, and delete catalog products, including name, description,
price, category, photos, and stock count.
- FR-22: The system shall let a store admin adjust a product's stock
count directly (e.g., to correct a count or restock).
- FR-23: The system shall let a store admin view all orders, view an
individual order's contents/customer/shipping details, and update an
order's fulfillment status (e.g., pending → shipped → delivered,
or cancelled).
- FR-24: The system shall let a store admin view basic sales/order
volume information (e.g., a list/count of orders and revenue over a
period).

## 4. Non-Functional Requirements

- NFR-1 (Security): All payment data shall be handled through a
PCI-compliant gateway; the system shall never persist raw card numbers,
CVV, or full magnetic-stripe/track data.
- NFR-2 (Security): Admin functionality shall be accessible only to
authenticated users holding the store-admin role; shopper accounts
shall not have access to admin functions.
- NFR-3 (Data integrity): Stock decrements shall be atomic with order
creation so concurrent checkouts cannot oversell a product, especially
important for one-of-a-kind pieces with a stock count of 1.
- NFR-4 (Availability): The public catalog and checkout flow shall be
available with high uptime; brief admin-side maintenance shall not take
down the shopper-facing storefront.
- NFR-5 (Performance): Catalog browse and search pages shall return
results within a couple of seconds under normal load.
- NFR-6 (Usability): The storefront shall be usable on both desktop and
mobile-width browsers, since handmade-goods shoppers frequently browse
on mobile.
- NFR-7 (Auditability): Every order shall retain an immutable record of
what was purchased, at what price, and its shipping address, even if
the underlying product listing is later edited or removed.

## 5. Success Criteria

- A shopper can browse the catalog, add an in-stock item to their cart,
complete checkout with a real payment gateway, and receive an order
confirmation, either as a guest or as a signed-in user.
- A store admin can add a new ceramic product with a stock count, see it
appear in the public catalog, and see it automatically marked sold out
once purchased quantity reaches that stock count.
- Concurrent checkout attempts on the last unit of a one-of-a-kind piece
result in exactly one successful order; the other purchaser sees a
clear sold-out message and is not charged.
- A signed-in shopper can view their order history and see accurate past
order details after their cart is cleared post-purchase.