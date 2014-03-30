namespace :users do
  desc "Removes anonymous users that haven't logged in in the past week"
  task :prune => :environment do
    Rails.logger.tagged(:rake, :users, :prune) {
      User.prune! 1.month.ago
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
