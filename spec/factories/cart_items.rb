FactoryBot.define do
  factory :cart_item do
    product
    cart
    quantity { 1 }
  end
end
