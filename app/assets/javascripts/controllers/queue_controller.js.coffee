Buzz.QueueController = Ember.ArrayController.extend
  sortProperties: ['idx']
  current_episodeBinding: 'queued_episodes.firstObject.episode'
  model:(-> Buzz.QueuedEpisode.find()).property('Buzz.QueuedEpisode')

  queued_episodes: (->
    this.get('model').sortBy('idx')
  ).property('model', 'model.@each', 'model.@each.idx')

  is_enqueued: (episode_id) ->
    this.get('model').mapProperty('episode.id').contains(episode_id)

  dequeue: (episode) ->
    queued_episode = this.get('model').find (qe) ->
      qe.get('episode') == episode

    queued_episode.deleteRecord()
    queued_episode.save()

  enqueue: (episode) ->
    # Idx is set to javascript's max int so it will be added to the end before getting it's
    # real index from the server..
    queued_episode = Buzz.QueuedEpisode.createRecord episode: episode, idx: 9007199254740992
    queued_episode.save()

  actions:
      markPlayed: () ->
        current_episode = this.get 'current_episode'

        # Mark the episode as played
        current_episode.set 'is_played', true
        current_episode.save()

        # Delete the queued episode, removing it from the queue
        queued_episode = this.get('current_episode')
        queued_episode.deleteRecord()
        queued_episode.save()

      setCurrentPosition: (position) ->
        this.get('current_episode').set('current_position', position)

      setDuration: (duration) ->
        current_episode = this.get('current_episode')
        if current_episode.get('duration') != duration
          current_episode.set('duration', duration)
          current_episode.save()
