Work in progress podcasting app built using Rails and Ember

## Getting started

### Database setup

This project is using postgresql because that is the databse supported by
Heroku. [Here are the postgres install instructions for Arch Linux](https://wiki.archlinux.org/index.php/Postgres)

1. Install postgres from your package manager
2. Switch to the `postgres` user
   `$ sudo -i -u postgres`
3. Initialize the postgres data store
  `[postgres]$ initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'`
4. Start the postgres service (If you use Systemd the command is `[you] $ systemctl start postgresql`)
5. Create the postgres user
  `[postgres]$ createuser --interactive`
  Username:  `<your username>`
  Superuser?: `n`
  Create Databases: `y`
  Create Rolls: `n`
6. `rake db:setup`

## Updating podcast feeds

### Manually

Run `$ rake feeds:update` to update all feeds.

### Cron through whenever

There is a schedule file in `config/schedule.rb` that defines cron tasks to run
`rake feeds:update` every two hours. Assuming you have cron enabled you should run:

`whenever -w -s 'environment=<RAILS_ENV>'`

where `<RAILS_ENV>` is `development` on a development box, and `production` if this is
a release server.

## Testing with Facebook login.

This app draws your facebook developer credentials from your system's
environment. To test and use facebook login while developing you will have
to create a facebook developer account and create an app.

### Facebook app setup.

1. Create the app.
   Go to `https://developers.facebook.com/apps/` and create an app named
  `buzz-dev`

2. Export the app's id and secret to our env.
   Go to the app's `settings` page and copy the `App ID` and `App Secret`
   into your shell's rc (likely `~/.bashrc` or `~/.zshrc`).

  ```
  export BUZZ_FACEBOOK_APP_ID='---------------'
  export BUZZ_FACEBOOK_SECRET='---------------'
  ```

  Ensure this information is not uploaded anywhere public. I use a `~/.keys`
  file that I source in my shell rc's instead so that I can make my rc's
  public.

  ```
  # ~/.zshenv

  #:: load credentials
  [[ -f "$HOME/.keys" ]] && source "$HOME/.keys";
  ```

3. Add a `website` platform
   Click Add platform and select website. For development testing set the 
  `Site URL` to `http://localhost:3000/`

