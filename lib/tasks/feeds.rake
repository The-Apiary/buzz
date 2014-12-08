
namespace :feeds do
  desc "Updates all podcasts and creates new episodes"
  task :update => :environment do
    start_time = Time.now.to_s #strftime('%d/%m/%Y %H:%M')

    Rails.logger.tagged('feeds:update', start_time) { Rails.logger.info "Getting new episodes from podcast feeds" }
    puts "Getting new episodes from podcast feeds"
    Podcast.find_each do |podcast|

      # Get old episodes to later diff against new episodes
      old_episodes = podcast.episodes.load.to_a
      old_categories = podcast.categories.load.to_a

      episode_errors = []

      #-- Update the podcast, and podcasts episodes
      begin
        # 0 second ttl to skips the cache
        podcast_data = Podcast.parse_feed podcast.feed_url, 0.seconds
      rescue OpenURI::HTTPError,
        Errno::ETIMEDOUT,
        Errno::ECONNRESET,
        SocketError,
        Exception  => ex

        puts "#{podcast.title}: Could not update feed #{ex.message}"
        Bugsnag.notify ex, podcast: {
          title: podcast.title,
          url:   podcast.feed_url
        }
        Rails.logger.tagged('feeds:update', start_time, podcast.title) { "Could not reache feed #{ex.message}" }
        next
      end

      # Map string categories to Categories
      podcast_data[:categories] = podcast_data[:categories].map do |name|
        Category.find_or_initialize_by(name: name)
      end

      # Update episode data
      episode_count = podcast_data[:episodes_attributes].count
      podcast_data.delete(:episodes_attributes).each do |ea|
        episode = podcast.episodes.find_or_initialize_by(audio_url: ea[:audio_url])
        unless episode.update ea
          episode_errors << episode.errors.full_messages
        end
      end

      # Update the podcasts attributes, this also creates new episodes
      podcast.attributes = podcast_data

      # Get old title, and changed attributes.
      title = podcast.title_was
      changed_attributes = podcast.changed_attributes.dup

      podcast.save

      # Diff created/removed episodes
      episodes = podcast.episodes.load.to_a
      added_episodes = episodes - old_episodes
      removed_episodes = old_episodes - episodes

      # Diff created/removed categories
      categories = podcast.categories.load.to_a
      added_categories = categories - old_categories
      removed_categories = old_categories - categories

      #-- Print changes to podcast or episodes
      puts "-> #{title}"
      changed_attributes.each do |attr, was|
        puts "    #{attr}: #{was} -> #{podcast[attr]}"
      end


      puts "    #{episode_errors.count}/#{episode_count} invalid episodes #{episode_errors.flatten.uniq}" if episode_errors.count > 0
      puts "    Added #{added_episodes.count} episodes" if added_episodes.any?
      puts "    Removed #{removed_episodes.count} episodes" if removed_episodes.any?

      puts "    Added #{added_categories.count} categories" if added_categories.any?
      puts "    Removed #{removed_categories.count} categories" if removed_categories.any?

      #-- Log changes to podcast or episodes
      update_messages = Array.new
      update_messages << "+#{added_episodes.count}" if added_episodes.any?
      update_messages << "-#{removed_episodes_episodes.count}" if removed_episodes.any?
      update_messages << "#{changed_attributes.count} attributes updated" if changed_attributes.any?
      update_messages << "#{episode_errors.count}/#{episode_count} invalid episodes" if episode_errors.count > 0
      Rails.logger.tagged('feeds:update', start_time, podcast.title) { Rails.logger.info update_messages.join(", ") } if update_messages.any?
    end
  end

  desc "Dumps feeds from heroku"
  task :dump => :environment do

    output_file = Rails.configuration.feed_dump_filename
    puts "Dumping feeds from heroku to #{output_file}"

    feed_sql = "SELECT feed_url from podcasts ORDER BY podcasts.feed_url"
    output = %x{echo '#{feed_sql}' | heroku pg:psql}

    # Drip sourounding marks that are not feeds.
    trimmed_output = output.lines[2..-3]

    File.open(output_file, "w") do |f|
      trimmed_output.each do |line|
        f.write line
      end
    end

    puts "Wrote #{trimmed_output.count} feed urls to #{output_file}"
  end

  desc "Experiment with feed parse code"
  task :test => :environment do
    #-- Change pre test code above
    Podcast.where(title: 'The Partially Examined Life Philosophy Podcast').each  do |pod|
      parsed = Podcast.parse_feed pod.feed_url, 0
    end
  end
end
