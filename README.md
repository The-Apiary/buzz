## README

Work in progress podcasting app built using Rails and Ember

## To Do

// Current Objectives
- [x] Persist Queue
- [x] Track played episodes
- [ ] Update feeds automatically
- [ ] Filter podcasts
- [ ] Track and resume episode position
- [ ] Infinite Scrollin'
- [ ] User accounts
  - [ ] Anonymous hashed accounts (30 day TTL?)
  - [ ] Facebook,Google,Twitter,Pesona, whatever login
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

- [x] JS Episode and QueuedEpisode should share info (changing one's duration should change the others)
- [ ] Move podcast rss parsing code out of instance methods into class methods
- [ ] Clean episode_data code in episode controller
- [ ] Replace emblem with hamlbars
- [ ] Why does The Moth podcast not work? (viewing the audio_url in a browser doesn't work either)
