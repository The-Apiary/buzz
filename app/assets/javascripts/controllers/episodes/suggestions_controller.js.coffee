filter = (episodes, type) ->
  episodes.filterBy('podcast.type', type)

Buzz.EpisodesSuggestionsController = Ember.ArrayController.extend
  news: (->
    filter(this.get('model'), 'News')
  ).property('model')

  serial: (->
    filter(this.get('model'), 'Serial')
  ).property('model')

  normal: (->
    filter(this.get('model'), 'Normal')
  ).property('model')
