class AddTypeToSubscription < ActiveRecord::Migration
  def change
    change_table :subscriptions do |t|
      t.text :subscription_type, null: false, default: :normal
    end
  end
end
