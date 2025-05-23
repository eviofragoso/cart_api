require 'rails_helper'

RSpec.describe UpdateCartItemsService, type: :service do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, price: 10.0) }

  describe '#call' do
    context 'when quantity is valid' do
      it 'creates a new cart item if not existing' do
        payload = { product_id: product.id, quantity: 3 }

        expect {
          described_class.new(cart, payload).call
        }.to change { cart.cart_items.count }.by(1)

        item = cart.cart_items.last
        expect(item.product).to eq(product)
        expect(item.quantity).to eq(3)
      end

      it 'updates the quantity of existing cart item' do
        existing_item = create(:cart_item, cart: cart, product: product, quantity: 2)
        payload = { product_id: product.id, quantity: 4 }

        result = described_class.new(cart, payload).call

        expect(result).to eq(existing_item)
        expect(result.reload.quantity).to eq(6)
      end
    end

    context 'when quantity is zero or negative' do
      it 'raises NegativeQuantityError for zero quantity' do
        payload = { product_id: product.id, quantity: 0 }

        expect {
          described_class.new(cart, payload).call
        }.to raise_error(NegativeQuantityError)
      end

      it 'raises NegativeQuantityError for negative quantity' do
        payload = { product_id: product.id, quantity: -1 }

        expect {
          described_class.new(cart, payload).call
        }.to raise_error(NegativeQuantityError)
      end
    end
  end
end
