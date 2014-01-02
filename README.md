Work in progress podcasting app built using Rails and Ember

# Notes

## To Do

// Current Objectives
- [x] Persist Queue
- [x] Track played episodes
- [x] Update feeds automatically (implemented, need to check that whenever is working)
- [x] Filter podcasts
- [x] Track and resume episode position
- [ ] User accounts
  - [ ] Anonymous hashed accounts (30 day TTL?)
  - [ ] Facebook,Google,Twitter,Pesona, whatever login
- [ ] Infinite Scrollin'
- [ ] Subscribe to podcasts

// Next Objectives
- [ ] Change episode queue to episode list (should be rearrangeable)
- [ ] Optimise for mobile and tablets
- [ ] Cache Episodes (sync to device for offline listening (might have to make mobile apps))
- [ ] Remote control

// Maybes
- [ ] Types of podcasts (Daily News podcasts won't be displayed after the day they aired)
- [ ] Ads
  - [ ] Banner ads (no audio/video ads)
  - [ ] Offer to donate portion of ad revenue to charity/public radio/podcast creators?

## Fixes

- [ ] investigate: Uncaught Error: Attempted to handle event `loadedData` on <Buzz.Episode:ember612:2773> while in state root.loaded.updated.uncommitted.
      - Did I fix this already? I think it was caused by changing an Ember object's attributes after saving it, but before the server responded to the save.
      - Could be fixed by preventing all saves until the server responds.
- [ ] Move podcast rss parsing code out of instance methods into class methods
- [ ] Clean episode_data code in episode controller
- [ ] Replace emblem with hamlbars
- [ ] Why does The Moth podcast not work? (viewing the audio_url in a browser doesn't work either)
- [ ] Add current time to rails logger
- [ ] Reduce initial load time
- [ ] Separate episode_data and episode in Ember
- [x] JS Episode and QueuedEpisode should share info (changing one's duration should change the others)

# Docs

## User Accounts

- [ ] Create user model.
- [ ] Create relationship between user, queue, and episode_data
- [ ] Create subscriptions and relate them to the user.
