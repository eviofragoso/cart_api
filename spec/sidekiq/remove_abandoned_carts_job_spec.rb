require 'rails_helper'
RSpec.describe RemoveAbandonedCartsJob, type: :job do 
  describe "#perform" do
    context "when there is carts with last interact older than 3 hours" do
      it "mark them as abandoned" do
        create_list(:cart, 2, last_interaction_at: 7.days.ago)

        expect do
          described_class.new.perform
        end.to change{ Cart.count }.by(-2)
      end
    end
  end
end
