#:: Podcasts Index Controller
Buzz.PodcastsIndexController = Ember.ArrayController.extend
  sortProperties: ['subscriptions_count']
  sortAscending: false
