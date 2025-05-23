require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "DELETE /:product_id" do
    let(:product) { create(:product, name: "Test Product", price: 10.0) }

    context 'when the product is associated to the cart' do
      before do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      subject do
        delete "/cart/#{product.id}", as: :json
      end

      it 'removes the product from the cart' do
        expect { subject }.to change(CartItem, :count).by(-1)
      end
    end

    context 'when the product_id does not exist' do
      before do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'removes the product from the cart' do
        delete "/cart/9999", as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq("Product not found in cart")
      end
    end
  end
    
  describe "POST /" do
    let(:product) { create(:product, name: "Test Product", price: 10.0) }

    context 'when there is no cart in the session' do

      subject do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change(Cart, :count).by(1)
      end
    end

    context 'when the cart is already associated' do
      before do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      subject do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'dont create another cart' do
        expect { subject }.to change(Cart, :count).by(0)
      end
    end
  end

  describe "POST /add_item" do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
    end

    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: "Test Product", price: 10.0) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      # INFO: Added this, because the test is creating a cart to be used when the logic for the cart creation is implemented in a callback 
      
  
      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
