class AddLastInteractionAtToCart < ActiveRecord::Migration[7.1]
  def change
    change_table :carts do |t|
      t.datetime :last_interaction_at
      t.boolean  :abandoned
    end
  end
end
