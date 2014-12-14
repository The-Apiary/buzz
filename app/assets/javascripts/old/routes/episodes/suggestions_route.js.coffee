Buzz.EpisodesSuggestionsRoute = Ember.Route.extend
  model: () ->
    subscriptions = this.store.find('podcast', subscribed: true)
    subscriptions.then (s) =>
      this.transitionTo('welcome') if s.get('length') == 0

    Ember.RSVP.hash
      news: this.store.find('episode', suggestions: "News")
      serial: this.store.find('episode', suggestions: "Serial")
      normal: this.store.find('episode', suggestions: "Normal", limit: 10)

Buzz.WelcomeRoute = Ember.Route.extend
  model: () ->
    Ember.RSVP.hash
      news: this.store.find('episode', suggestions: "News", sample: true)
      serial: this.store.find('episode', suggestions: "Serial", sample: true)
      normal: this.store.find('episode', suggestions: "Normal", limit: 10, sample: true)
