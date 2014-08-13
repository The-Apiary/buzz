json.(podcast, :id, :title, :description, :link_url, :image_url, :feed_url, :subscriptions_count)
json.subscription_id podcast.subscription_id(current_user)
json.categories podcast.category_names
