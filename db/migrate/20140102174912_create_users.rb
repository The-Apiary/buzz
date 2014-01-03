# Create the user table, and add user_id forign keys to episode_data and queued_epoisodes
class CreateUsers < ActiveRecord::Migration
  def change

    # Create the user table
    create_table :users do |t|
      t.string :id_hash, index: true
      t.timestamps
    end

    # Add indexed user forign keys to episode_data and queued_episodes
    [:episode_data, :queued_episodes].each do |table|
      change_table(table) { |t| t.references :user, index: true }
    end
  end
end
