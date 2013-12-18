namespace :podcasts do
  desc "Checks all podcast feeds and creates new episodes"
  task :check_feeds => :environment do
    Podcast.find_each do |podcast|
      puts "#{podcast.title}: #{podcast.get_episodes_from_feed!.count} new episodes"
    end
  end
end
