class RemoveEpisodeQueues < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :episode_queues
      drop_table :episode_queues
    end
  end
end
