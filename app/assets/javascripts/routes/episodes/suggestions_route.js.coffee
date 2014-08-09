Buzz.EpisodesSuggestionsRoute = Ember.Route.extend
  model: () ->
    this.store.find('episode', suggestions: true)

