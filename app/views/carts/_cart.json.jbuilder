json.id cart.id

json.products do
  json.array! cart.cart_items do |cart_item|
    product = cart_item.product
  
    json.id product.id
    json.name product.name
    json.quantity cart_item.quantity
    json.unit_price cart_item.unit_price
    json.total_price cart_item.total_price
  end
end

json.total_price cart.total_price