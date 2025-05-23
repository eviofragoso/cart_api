class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_items
  has_many :products, through: :cart_items

  def mark_as_abandoned
    return unless last_interaction_at <= 3.hours.ago

    update!(abandoned: true)
  end

  def remove_if_abandoned
    return unless abandoned? && last_interaction_at <= 7.days.ago

    destroy
  end
end
