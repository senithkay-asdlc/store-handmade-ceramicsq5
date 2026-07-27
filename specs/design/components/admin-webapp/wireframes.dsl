// Admin Console — store owner flow

screen ProductList "The store admin manages the product catalog"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Reports | Sign out"
  row
    heading "Products"
    right
    search "Search products…"
    button "New product" primary -> ProductEdit
  table "Product | Category | Price | Stock | Status" -> ProductEdit
    row "Sea Glaze Mug | Mugs | $28 | 3 | Published"
    row "Rustic Bowl Set | Bowls | $64 | 1 | Published"
    row "Amber Vase | Vases | $95 | 0 | Sold out"

screen ProductEdit "The admin creates or edits one product, including stock"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Reports | Sign out"
  breadcrumb "Products / Sea Glaze Mug"
  heading "Edit Product"
  input "Name — Sea Glaze Mug"
  textarea "Description"
  row
    select "Category: Mugs"
    input "Price — 28.00"
  input "Stock count — 3"
  image "Photo 1"
  toggle "Published" active
  row
    right
    button "Delete" danger
    button "Save changes" primary -> ProductList

screen OrderQueue "The admin views incoming orders and updates fulfillment"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Reports | Sign out"
  row
    heading "Orders"
    right
    select "Status: All"
  table "Order # | Customer | Total | Status | Date" -> OrderDetail
    row "CER-10482 | J. Alvarez | $135.80 | Pending | Jul 20"
    row "CER-10310 | R. Kim | $28.00 | Shipped | Jun 02"

screen OrderDetail "The admin reviews one order and updates its status"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Reports | Sign out"
  breadcrumb "Orders / CER-10482"
  row
    heading "Order CER-10482"
    badge "Pending" warning
  text "J. Alvarez — j.alvarez@example.com"
  split 60/40
    left
      table "Product | Price | Quantity"
        row "Sea Glaze Mug | $28 | 2"
        row "Rustic Bowl Set | $64 | 1"
      text "Subtotal $120 · Shipping $6 · Tax $9.80 · Total $135.80"
    right
      card "Shipping address"
        text "J. Alvarez"
        text "44 Kiln Rd, Springfield"
      select "Fulfillment status: Pending"
      button "Update status" primary -> OrderQueue

screen SalesReport "The admin views basic sales/order-volume reporting"
  navbar "Ceramics Admin"
  sidebar "Products | Orders | Reports | Sign out"
  row
    heading "Sales Report"
    right
    select "Period: Last 30 days"
  row
    card "Orders | 42 | last 30 days"
    card "Revenue | $3,940 | last 30 days"
    card "Avg order | $93.80 | last 30 days"
  chart "Daily revenue" 600x260
