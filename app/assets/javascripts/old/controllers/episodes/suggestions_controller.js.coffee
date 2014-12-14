Buzz.EpisodesSuggestionsController = Ember.ObjectController.extend
  needs_subscriptions: (->
    return this.get('subscriptions.length') == 0;
  ).property('subscriptions')
