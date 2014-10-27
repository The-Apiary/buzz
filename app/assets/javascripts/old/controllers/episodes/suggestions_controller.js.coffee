Buzz.EpisodesSuggestionsController = Ember.ObjectController.extend
  needs_subscriptions: (->
    return true;
  ).property('subscriptions')
