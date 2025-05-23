class CartsController < ApplicationController
  before_action :set_session_cart, only: [:create]
  before_action :set_cart

  def show; end

  def add_item
    UpdateCartItemsService.new(@cart, add_item_params).call
  rescue NegativeQuantityError
    render json: { error: "Product quantity to associate must be positive" }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid  => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  
  def create
    add_item
  end

  def remove_item
    cart_item = @cart.cart_items.find_by!(product_id: params[:product_id])

    cart_item.destroy!  
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Product not found in cart" }, status: :not_found
  end

  private

  def add_item_params
    params.permit(:product_id, :quantity)
  end

  def set_cart
    return if @cart

    @cart = Cart.find(session[:cart_id])
  end

  def set_session_cart
    return if session[:cart_id]

    cart = Cart.create(total_price: 0)
    session[:cart_id] = cart.id
  end
  
end
