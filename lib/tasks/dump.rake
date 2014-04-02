namespace :dump do
  desc "Dumps feeds from heroku"
  task :feeds => :environment do
    feed_sql = "SELECT feed_url from podcasts"

    output_file = Rails.configuration.feed_dump_filename
    puts "Dumping feeds from heroku to #{output_file}"

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
end
