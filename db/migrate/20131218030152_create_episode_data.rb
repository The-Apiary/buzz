class CreateEpisodeData < ActiveRecord::Migration
  def change
    create_table :episode_data do |t|
      t.references :episode
      t.integer  :current_position, default: 0
      t.boolean    :is_played
    end
  end
end
