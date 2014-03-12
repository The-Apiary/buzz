Work in progress podcasting app built using Rails and Ember

## Updating podcast feeds

### Manually

Run `$ rake feeds:update` to update all feeds.

### Cron through whenever

There is a schedule file in `config/schedule.rb` that defines cron tasks to run
`rake feeds:update` every two hours. Assuming you have cron enabled you should run:

`whenever -w -s 'environment=<RAILS_ENV>'`

where `<RAILS_ENV>` is `development` on a development box, and `production` if this is
a release server.
