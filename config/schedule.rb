# Run whenever -w to write these settings to the cron tables
# use -s 'environment=development' to run the tasks in development

every 2.hours do
 rake "podcasts:check_feeds"
end
