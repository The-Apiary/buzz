
namespace :podcasts do
  task :check => :environment do
    Rails.logger.tagged(Time.now.strftime('%d/%m/%Y %H:%M')) {
      Rails.logger.tagged('Update Feeds') {
        Rails.logger.info "cron works"
      }
    }
  end
  desc "Checks all podcast feeds and creates new episodes"
  task :check_feeds => :environment do
    all_new_episodes = Array.new
    Podcast.find_each do |podcast|
      begin
        new_episodes = podcast.get_episodes_from_feed!
        if new_episodes.count > 0
          all_new_episodes += new_episodes
        end
      rescue => ex
        Rails.logger.tagged(Time.now.strftime('%d/%m/%Y %H:%M')) {
          Rails.logger.tagged('Update Feeds') {
            Rails.logger.error "#{podcast.title}: #{ex.message}"
          }
        }
      end
    end
    Rails.logger.tagged(Time.now.strftime('%d/%m/%Y %H:%M')) {
      Rails.logger.tagged('Update Feeds') {
        Rails.logger.info "#{all_new_episodes.count} new episodes"
      }
    }
  end
end
