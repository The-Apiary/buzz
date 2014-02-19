# For more information see: http://emberjs.com/guides/routing/

Buzz.Router.map () ->
  this.route 'recent', path: '/recent'
  this.route 'subscriptions', path: '/subscriptions'
  this.route 'podcast', path: '/podcasts/:id'
