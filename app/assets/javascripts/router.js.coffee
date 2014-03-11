# For more information see: http://emberjs.com/guides/routing/

Buzz.Router.map () ->
  this.route 'recent', path: '/recent'
  this.route 'subscriptions', path: '/subscriptions'
  this.resource 'podcast', path: '/podcasts', ->
    this.route 'show', path: '/:id'
    this.route 'new', path: 'new/:query'
  this.route 'search', path: '/search/:query'
  this.route 'add_feed', path: '/add_feed/:query'
