class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.where(last_interaction_at: ..3.hours.ago).update(abandoned: true)
  end
end
