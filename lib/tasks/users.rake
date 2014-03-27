namespace :users do
  desc "Removes anonymous users that haven't logged in in the past week"
  task :prune => :environment do
    Rails.logger.tagged(:rake, :users, :prune) {
      inactive_users = User.anonymous.inactive_since(1.month.ago)

      message = "Destroying #{inactive_users.count} inactive users"
      Rails.logger.info message
      puts message
    }
  end

  desc "Prints user statistics"
  task :stats => :environment do
    Rails.logger.tagged(:rake, :users, :stats) {
      t = 1.week.ago
      inactive_users = User.inactive_since t
      active_users = User.active_since t

      message = "#{inactive_users.count} inactive_users, " +
        "#{active_users.count} active_users " +
        "since #{t}"
      Rails.logger.info message
      puts message
    }
  end
end
