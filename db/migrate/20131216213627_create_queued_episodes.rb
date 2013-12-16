class CreateQueuedEpisodes < ActiveRecord::Migration
  def change
    create_table :queued_episodes do |t|
      t.references :episode
    end
  end
end
