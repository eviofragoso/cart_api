require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'when validating' do
    it 'validates numericality of quantity' do
      cart_item = described_class.new(quantity: -1)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:quantity]).to include("must be greater than or equal to 0")
    end

    it 'validates presence of quantity' do
      cart_item = build(:cart_item, quantity: nil)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors[:quantity]).to include("can't be blank")
    end
  end

  context 'when calculation price' do
    it 'calculates total price based on its quantity and product price' do
      product = create(:product, price: 12.0)
      cart_item = create(:cart_item, quantity: 2, product: product)
      expect(cart_item.total_price).to eq(product.price * cart_item.quantity)
    end  
  end

  context "when updating its cart's price" do
    let(:cart) { create(:cart, total_price: 5.0) }
    let(:product) { create(:product, price: 12.0) }

    it 'cart total price is updated when new cart item is added' do
      cart_item = create(:cart_item, quantity: 2, product: product, cart: cart)
      expect(cart.reload.total_price).to eq(product.price * cart_item.quantity)
    end

    it 'cart total price is updated when cart item is update' do
      cart_item = create(:cart_item, quantity: 2, product: product, cart: cart)
      cart_item.update!(quantity: 8)
      expect(cart.reload.total_price).to eq(product.price * cart_item.quantity)
    end

    it 'cart total price is updated when cart item is destroyed' do
      cart_item = create(:cart_item, quantity: 3, product: product, cart: cart)
      cart_item.destroy
      expect(cart.reload.total_price).to eq(0)
    end
  end
end
