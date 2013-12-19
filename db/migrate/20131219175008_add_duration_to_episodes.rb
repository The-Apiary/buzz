class AddDurationToEpisodes < ActiveRecord::Migration
  def change
    change_table :episodes do |t|
      t.integer :duration
    end
  end
end
