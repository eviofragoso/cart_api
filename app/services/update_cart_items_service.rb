class NegativeQuantityError < StandardError; end

class UpdateCartItemsService
  def initialize(cart, payload)
    @cart    = cart
    @payload = payload
  end

  def call
    validate_quantity
    cart_item = initialize_cart_item
    persist_cart_item(cart_item)
  
    cart_item
  end

  private

  def validate_quantity
    raise NegativeQuantityError if @payload[:quantity] <= 0
  end

  def initialize_cart_item
    @cart.cart_items.where(product_id: @payload[:product_id]).first_or_initialize
  end

  def persist_cart_item(cart_item)
    cart_item.quantity = (cart_item.quantity || 0) + @payload[:quantity]
    cart_item.save!
  end
end