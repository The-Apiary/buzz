
namespace :feeds do
  desc "Updates all podcasts and creates new episodes"
  task :update => :environment do
    start_time = Time.now.to_s #strftime('%d/%m/%Y %H:%M')

    Rails.logger.tagged('feeds:update', start_time) { Rails.logger.info "Getting new episodes from podcast feeds" }
    puts "Getting new episodes from podcast feeds"
    Podcast.find_each do |podcast|

      # Get old episodes to later diff against new episodes
      old_episodes = podcast.episodes.load.to_a

      #-- Update the podcast, and podcasts episodes
      podcast_data = Podcast.parse_feed podcast.feed_url
      podcast.attributes = podcast_data


      # Get old title, and changed attributes.
      title = podcast.title_was
      changed_attributes = podcast.changed_attributes.dup

      podcast.save

      # Diff created/removed episodes
      episodes = podcast.episodes.load.to_a
      added_episodes = episodes - old_episodes
      removed_episodes = old_episodes - episodes

      #-- Print changes to podcast or episodes
      puts "-> #{title}"
      changed_attributes.each do |attr, was|
        puts "    #{attr}: #{was} -> #{podcast[attr]}"
      end
      puts "    Added #{added_episodes.count} episodes" if added_episodes.any?
      puts "    Removed #{removed_episodes.count} episodes" if removed_episodes.any?

      #-- Log changes to podcast or episodes
      update_messages = Array.new
      update_messages << "+#{added_episodes.count}" if added_episodes.any?
      update_messages << "-#{removed_episodes_episodes.count}" if removed_episodes.any?
      update_messages << "#{changed_attributes.count} attributes updated" if changed_attributes.any?
      Rails.logger.tagged('feeds:update', start_time, podcast.title) { Rails.logger.info update_messages.join(", ") } if update_messages.any?
    end
  end
end
