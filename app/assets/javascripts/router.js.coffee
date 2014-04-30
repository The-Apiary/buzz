# For more information see: http://emberjs.com/guides/routing/

Buzz.Router.map () ->
  this.route 'subscriptions', path: '/subscriptions'

  this.resource 'categories', path: '/categories', ->
    this.route 'show', path: '/:name'

  this.resource 'podcasts', path: '/podcasts', ->
    this.route 'new', path: '/new'
    this.route 'show', path: '/:id', ->

  this.resource 'episodes', path: '/episodes', ->
    this.route 'latest', path: '/latest', ->
    this.route 'listened', path: '/listened', ->
    this.route 'show', path: '/:id', ->

  this.route 'search', path: '/search/:query'
  this.route 'add_feed', path: '/add_feed/:query'
