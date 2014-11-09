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

7. `$ guard` runs tests when files change.

## Updating podcast feeds

### Manually

Run `$ rake feeds:update` to update all feeds.

## Facebook login.

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

### Currently working on

## Remote control
**Branch:** remote

Rdio like remote control through websockets.

[x] Munaully set player to `local` or `remote`.
[x] Audio events and controls are sent through the socket.
[ ] Ensure only one player is `local` and the others are `remote`.
[ ] Current episode and queue information need to be syncronized through
the socket.

## Testing
**Branch:** test

Create automated tests

**Models:**
 [X] category
 [X] episode
 [X] feed_cache
 [X] podcast
 [X] queued_episode
 [ ] queue_manager
 [ ] subscription
 [ ] user

**Controllers:**
 [ ] categories_controller
 [ ] episodes_controller
 [ ] podcasts_controller
 [ ] queued_episodes_controller
 [ ] subscriptions_controller

**Javascript:**
 [ ] All of it.
