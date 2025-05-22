require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end
 
  describe "when there is no cart associated to the session" do
    it "creates a new cart and associates to the session" do
      expect { get :index }.to change(Cart, :count).by(1)
      expect(session[:cart_id]).to eq(Cart.last.id)
    end
  end

   describe "when there is a cart associated to the session" do
    before do
      get :index
      @cart_id = session[:cart_id] 
    end

    it "doesn't create a new cart" do
      expect { get :index }.to change(Cart, :count).by(0)
      expect(session[:cart_id]).to eq(@cart_id)
    end
  end
end