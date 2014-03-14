# For more information see: http://emberjs.com/guides/routing/

Buzz.Router.map () ->
  this.route 'recent', path: '/recent'
  this.route 'subscriptions', path: '/subscriptions'
  this.resource 'podcasts', path: '/podcasts', ->
    this.route 'new', path: 'new'
    this.route 'show', path: '/:id'
  this.route 'search', path: '/search/:query'
  this.route 'add_feed', path: '/add_feed/:query'
