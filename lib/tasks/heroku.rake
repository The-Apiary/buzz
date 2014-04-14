namespace :heroku do
  desc "Run regular maintianance tasks on the heroku server"
  task :maintain => :environment do
    puts '> Updating feeds'
    system 'heroku run rake feeds:update'

    puts '> Backing up feed list'
    system 'rake feeds:dump'

    puts '> Pruning inavtive users'
    system 'heroku run rake users:stats users:prune'
  end
end

