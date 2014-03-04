Buzz.QueueController = Ember.ArrayController.extend
  queued_episodes: (-> Buzz.QueuedEpisode.find()).property()
