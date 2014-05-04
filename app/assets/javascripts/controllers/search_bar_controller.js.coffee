Buzz.SearchBarController = Ember.ObjectController.extend
  needs: ['application']
  query: null

  escaped_query: (->
    encodeURIComponent(this.get('query'))
  ).property('query')

  actions:
    search: ->
      this.get('controllers.application').transitionToRoute('search', this.get 'escaped_query')
      return false

