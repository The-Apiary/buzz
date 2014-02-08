Work in progress podcasting app built using Rails and Ember

[ ] Embed episode_data instead of sideloading

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

- [ ] Move podcast rss parsing code out of instance methods into class methods
- [ ] Replace emblem with hamlbars
- [ ] Why does The Moth podcast not work? (viewing the audio_url in a browser doesn't work either, and didn't work in previous podcatcher)
- [ ] Add current time to rails logger
- [ ] Reduce initial load time (it's even worse now)
- [ ] Queued episodes appear in episode list before newer unqueued episodes

# Routes

| Url      | Controller   | Description                                             |
| /        | ember#start  | Creates new anonymous user and redirects to the player  |
| /(:hash) | ember#player | Loads subscriptions for the player with the passed hash |
