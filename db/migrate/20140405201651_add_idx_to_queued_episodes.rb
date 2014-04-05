class AddIdxToQueuedEpisodes < ActiveRecord::Migration
  def change
    change_table :queued_episodes do |t|
      t.integer :idx, default: 0
    end
  end
end
