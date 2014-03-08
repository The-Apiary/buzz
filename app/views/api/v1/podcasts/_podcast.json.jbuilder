json.(podcast, :id, :title, :description, :image_url, :feed_url)
json.subscription_id current_user.subscriptions.find_by_podcast_id(podcast.id).try(:id)
