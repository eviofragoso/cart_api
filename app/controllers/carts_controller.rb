class CartsController < ApplicationController
  def add_item
    UpdateCartItemsService.new(session[:cart_id], add_item_params).call

    render json: @current_cart, include: [:products]
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cart not found" }, status: :bad_request
  end

  private

  def add_item_params
    params.permit(:product_id, :quantity)
  end
end
