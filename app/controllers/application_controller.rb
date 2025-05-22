class ApplicationController < ActionController::API
  before_action :check_session_cart

  private

  def check_session_cart
    return if session[:cart_id]

    cart = Cart.create(total_price: 0)
    session[:cart_id] = cart.id
  end
end
