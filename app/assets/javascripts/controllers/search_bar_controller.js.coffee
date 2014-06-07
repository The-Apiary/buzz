Buzz.SearchBarController = Ember.ObjectController.extend
  needs: ['application']
  query: null
  focused: false
  podcasts: []
  episodes: []

  # Debounces updates to the podcasts and episodes properties.
  search: ( ->
    self = this
    update = (query) ->
      if _.isString(query) && query.length >= 3
        Buzz.Podcast.find(search: true, q: query, limit: 10).then(
          (podcasts) -> self.set('podcasts', podcasts)
        )
        Buzz.Episode.find(search: true, q: query, limit: 10).then(
          (episodes) -> self.set('episodes', episodes)
        )
      else
        self.set('podcasts', [])
        self.set('episodes', [])
    Ember.run.debounce(self, update, self.get('query'), 300)
    return null
  ).observes('query')

  focus_changed: ( (key, val) ->
    Ember.run.debounce(this, 'set', 'focused', val, 200)
  ).property()

  # Display the dropdown where the search matches any podcasts or episodes
  display_dropdown: ( ->
    if this.get('query.length') > 0 && this.get('focused') &&
        (this.get('podcasts.length') > 0 || this.get('episodes.length') > 0)
      'display: block;'
    else
      'display: none;'
  ).property('podcasts.length', 'episodes.length', 'focused')

  escaped_query: (->
    encodeURIComponent(this.get('query'))
  ).property('query')

  actions:
    search: ->
      this.get('controllers.application').transitionToRoute('search', this.get 'escaped_query')
      return false

