Buzz.ApplicationController = Ember.ObjectController.extend
  # FIXME: I think this should be in the search view.
  query: null

  actions:
    search: ->
      this.transitionToRoute('search', this.get 'query')
