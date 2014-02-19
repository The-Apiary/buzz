Buzz.PodcastController = Ember.ObjectController.extend
  episodes: (() ->
      Buzz.Episode.find({podcast_id: this.get('model.id')})
  ).property('model')
