class AddSubscriptionsCountToPodcast < ActiveRecord::Migration
  def change
    change_table :podcasts do |t|
      t.integer :subscriptions_count, default: 0
    end

    Podcast.reset_column_information
    Podcast.all.each do |pod|
      pod.update_attribute :subscriptions_count, pod.subscriptions.count
    end
  end
end
