class AddSubscriptionsCountToPodcast < ActiveRecord::Migration
  def change
    change_table :podcasts do |t|
      t.integer :subscriptions_count, default: 0
    end

    Podcast.reset_column_information
    Podcast.find_each do |pod|
      Podcast.reset_counters pod.id, :subscriptions
    end
  end
end
