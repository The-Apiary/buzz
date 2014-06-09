Buzz.QueueController = Ember.ArrayController.extend
  sortProperties: ['idx']
  current_episodeBinding: 'queued_episodes.firstObject.episode'

  model:(->
    this.store.find('queued_episode')
  ).property()

  queued_episodes: (->
    this.get('model').sortBy('idx').mapBy('episode')
  ).property('model', 'model.@each', 'model.@each.idx')

  is_enqueued: (episode) ->
    queued_episode = this.get('queued_episodes')
      .findBy('id', episode.get('id'))

    return queued_episode != undefined

  remove: (episode) ->
    queued_episode = this.get('model').findBy 'episode.id', episode.get 'id'

    if queued_episode
      queued_episode.deleteRecord()
      queued_episode.save()

  push: (episode) ->
    # Idx is set to javascript's max int so it will be added to the end
    # before getting it's real index from the server..
    queued_episode = this.store.createRecord 'queued_episode',
      episode: episode,
      idx: 9007199254740992

    queued_episode.save()

  unshift: (episode) ->
    # Idx is set to javascript's min int so it will be added to the
    # beginning before getting it's real index from the server..
    queued_episode = this.store.createRecord 'queued_episode',
      episode: episode,
      idx: -9007199254740992
      unshift: true

    queued_episode.save()
