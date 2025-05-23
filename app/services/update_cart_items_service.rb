class UpdateCartItemsService
  def initialize(cart_id, payload)
    @cart    = Cart.find(cart_id)
    @payload = payload
  end

  def call
    cart_item = initialize_cart_item
    persist_cart_item(cart_item)
  
    cart_item
  end

  private

  def initialize_cart_item
    @cart.cart_items.where(product_id: @payload[:product_id]).first_or_initialize
  end

  def persist_cart_item(cart_item)
    cart_item.quantity = (cart_item.quantity || 0) + @payload[:quantity]
    cart_item.save!
  end
end