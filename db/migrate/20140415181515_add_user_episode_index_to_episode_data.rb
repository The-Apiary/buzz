class AddUserEpisodeIndexToEpisodeData < ActiveRecord::Migration
  def change
    change_table :episode_data do |t|
      t.index [:user_id, :episode_id]
    end
  end
end
