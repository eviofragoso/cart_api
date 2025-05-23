require 'rails_helper'
RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe "#perform" do
    context "when there is carts with last interact older than 3 hours" do
      it "mark them as abandoned" do
        abandoned_cart = create(:cart, last_interaction_at: 3.hours.ago, abandoned: false)
        described_class.new.perform

        expect(abandoned_cart.reload.abandoned).to be_truthy
      end
    end
  end
end
