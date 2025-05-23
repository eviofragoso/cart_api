class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  after_create  :update_cart_total_price
  after_update  :update_cart_total_price
  after_destroy :update_cart_total_price


  def unit_price
    product.price
  end

  def total_price
    quantity * unit_price
  end

  private

  def update_cart_total_price
    cart.update_total_price
  end
end
