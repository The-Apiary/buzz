# Seed podcasts from the latest heroku dump.
feeds_dump = Rails.configuration.feed_dump_filename
podcast_urls = File.open(feeds_dump, 'r').each_line.map(&:strip)

puts "Creating podcasts"
podcast_urls.each do |url|
  podcast = Podcast.create_from_feed_url url

  p podcast.errors.to_a unless podcast.save

  puts "-> title: #{podcast.title}"
  puts "    feed_url: #{podcast.feed_url}"
  puts "   image_url: #{podcast.image_url}"
  puts "    episodes: #{podcast.episodes.count}"
  puts "  categories: #{podcast.categories.count}"
end

puts "Now #{Podcast.count} podcasts"
puts "#{Episode.count} episodes"

user = User.create(id_hash: 'test') # Create test user with 'test' as it's identifyer
puts "Created user with id_hash: #{user.id_hash}"

# subscribe user to all seed podcasts
Podcast.find_each { |podcast| user.subscriptions.create podcast: podcast }
puts "user is now subscribed to #{user.subscriptions.count} podcasts"


