# Be sure to restart your server when you modify this file.

# I'm not sure if the data needs to be included in the filename
# filename = "#{Time.now.strftime('%d-%m-%y')}_feeds_dump"
filename = "feeds_dump"

feeds_dump_filename = File.join [ Rails.root, "lib", "assets", filename ]
Buzz::Application.config.feed_dump_filename = feeds_dump_filename
