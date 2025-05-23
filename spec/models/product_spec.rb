require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when validating' do
    it 'validates presence of name' do
      product = described_class.new(price: 100)
      expect(product.valid?).to be_falsey
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of price' do
      product = described_class.new(name: 'name')
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'validates numericality of price' do
      product = described_class.new(price: -1)
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end
  end

  context 'when calculation price' do
    it 'calculates total price based on its quantity and product price' do
      product = create(:product, price: 12.0)
      cart_item = create(:cart_item, quantity: 2, product: product)
      expect(cart_item.total_price).to eq(product.price * cart_item.quantity)
    end  
  end
end
