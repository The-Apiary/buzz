Buzz.EpisodesSuggestionsRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      subscriptions: this.store.find('podcast', subscribed: true)
      news: this.store.find('episode', suggestions: "News")
      serial: this.store.find('episode', suggestions: "Serial")
      normal: this.store.find('episode', suggestions: "Normal", limit: 10)

