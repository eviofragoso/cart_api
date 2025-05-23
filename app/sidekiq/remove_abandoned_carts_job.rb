class RemoveAbandonedCartsJob
  include Sidekiq::Job

  def perform(*args)
    Cart.where(last_interaction_at: ..7.days.ago).destroy_all
  end
end
