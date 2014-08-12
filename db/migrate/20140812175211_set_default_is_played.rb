class SetDefaultIsPlayed < ActiveRecord::Migration
  def up
    change_column :episode_data, :is_played, :boolean, :default => false

    EpisodeData.where(is_played: nil).update_all(is_played: false)
  end

  def down
  end
end
