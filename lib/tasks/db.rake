namespace :db do
  namespace:heroku do
    desc "Loads the heroku database into the development db."
    task :load => :environment do
      # NOTE: Should this be a bash script instead of shelling out?
      config = Rails.configuration.database_configuration[Rails.env]

      puts "Backing up heroku database"
      %x{heroku pgbackups:destroy}
      %x{heroku pgbackups:capture}

      puts "Loading backup into development"
      o = [
        "--verbose",
        "--clean",
        "--no-acl",
        "--no-owner",
        "-h #{config['host'] || 'localhost'}",
        "-d #{config['database']}",
        "-U #{config['username'] || %x{whoami}}",
      ]

      puts o

      # Outputs the database dump to stdout.
      dump_command = "curl -s `heroku pgbackups:url`"

      # Restores the data from the dump.
      load_command = "#{dump_command} | pg_restore #{o.join(' ')}"

      exec "bash -c '#{load_command}'"
    end
  end
end
