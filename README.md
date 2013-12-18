## README

Work in progress podcasting app built using Rails and Ember

## To Do

- [x] Persist Queue
- [ ] Track played episodes
- [ ] Update feeds automatically
- [ ] User accounts
  - [ ] Anonymous hashed accounts (30 day TTL?)
  - [ ] Facebook,Google,Twitter,Pesona login
- [ ] Subscribe to podcasts
- [ ] Filter podcasts
- [ ] Infinite Scrollin'
- [ ] Types of podcasts (Daily News podcasts won't be displayed after
                    the day they aired)

- [ ] Cache Episodes (sync to device for offline listening)
- [ ] Remote control
- [ ] Ads
  - [ ] Banner ads (no audio/video ads)
  - [ ] Offer to donate portion of ad revenue to charity

## Fixes

- [ ] Move podcast rss parsing code out of instance methods into class methods
- [x] JS Episode and QueuedEpisode should share info (changing one's duration should change the others)
- [x] What does Ember's RESTful adapter expect in response to a delete request?
