# Be sure to restart your server when you modify this file.

# Settings for the feed_cache.

Buzz::Application.config.feed_cache_dir = File.join(Rails.root, 'tmp', 'feeds')
Buzz::Application.config.feed_cache_ttl = 1.hour
