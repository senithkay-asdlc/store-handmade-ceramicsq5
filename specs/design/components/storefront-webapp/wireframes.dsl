// Ceramics Storefront — public shopper-facing flow

screen Catalog "Shoppers browse and search published ceramic products"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  row
    heading "Handmade Ceramics"
    right
    search "Search mugs, bowls, vases…"
    select "Category: All"
  row
    card "Sea Glaze Mug | $28 | Stoneware, 12oz"
    card "Rustic Bowl Set | $64 | Set of 2, one-of-a-kind"
    card "Amber Vase | Sold out | Unique piece"
  row
    right
    button "View all" -> ProductDetail

screen ProductDetail "A shopper views one product and adds it to their cart"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  breadcrumb "Shop / Mugs / Sea Glaze Mug"
  split 60/40
    left
      image "Sea Glaze Mug photo"
      heading "Sea Glaze Mug"
      text "Hand-thrown stoneware mug with a sea-glaze finish. Dishwasher safe."
      text "Category: Mugs"
    right
      card "Price | $28 | 3 in stock"
      select "Quantity: 1"
      button "Add to cart" primary -> Cart
      badge "In stock" success

screen Cart "A shopper reviews cart contents before checking out"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  heading "Your Cart"
  table "Product | Price | Quantity | Line total"
    row "Sea Glaze Mug | $28 | 2 | $56"
    row "Rustic Bowl Set | $64 | 1 | $64"
  row
    right
    text "Subtotal: $120"
  row
    right
    button "Continue shopping" -> Catalog
    button "Checkout" primary -> Checkout

screen Checkout "A shopper enters shipping + payment as guest or signed in"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  heading "Checkout"
  split 60/40
    left
      heading "Shipping address"
      input "Full name"
      input "Address line 1"
      input "City"
      row
        input "State/Region"
        input "Postal code"
      heading "Payment"
      input "Card number"
      row
        input "Expiry"
        input "CVV"
    right
      card "Order summary"
        text "Sea Glaze Mug x2 — $56"
        text "Rustic Bowl Set x1 — $64"
        text "Shipping — $6"
        text "Tax — $9.80"
        text "Total — $135.80"
      button "Place order" primary -> OrderConfirmation
      text "Checking out as guest — sign in to save this address"

screen OrderConfirmation "A shopper sees confirmation after successful payment"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  heading "Order confirmed"
  badge "Paid" success
  text "Order #CER-10482 — a confirmation has been sent to your email."
  table "Product | Price | Quantity"
    row "Sea Glaze Mug | $28 | 2"
    row "Rustic Bowl Set | $64 | 1"
  text "Total charged: $135.80"
  row
    right
    button "Back to shop" -> Catalog
    button "View my orders" primary -> OrderHistory

screen OrderHistory "A signed-in shopper views their past orders"
  navbar "Ceramics Co. | Shop | Cart | Orders | Sign in"
  heading "My Orders"
  table "Order # | Date | Total | Status"
    row "CER-10482 | Jul 20 | $135.80 | Shipped"
    row "CER-10310 | Jun 02 | $28.00 | Delivered"
  text "Sign in required — guest orders are confirmed by email only"
