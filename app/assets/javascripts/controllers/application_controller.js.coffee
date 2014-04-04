Buzz.ApplicationController = Ember.ObjectController.extend
  # FIXME: I think this should be in the search view.
  query: null

  escaped_query: (->
    encodeURIComponent(this.get('query'))
  ).property('query')

  actions:
    search: ->
      this.transitionToRoute('search', this.get 'escaped_query')
