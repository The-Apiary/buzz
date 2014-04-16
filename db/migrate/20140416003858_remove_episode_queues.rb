class RemoveEpisodeQueues < ActiveRecord::Migration
  def change
    drop_table :episode_queues
  end
end
