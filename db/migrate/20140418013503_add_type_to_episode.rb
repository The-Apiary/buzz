class AddTypeToEpisode < ActiveRecord::Migration
  def change
    change_table :episodes do |t|
      t.string :episode_type
    end
  end
end
