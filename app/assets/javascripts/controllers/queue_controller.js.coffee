Buzz.QueueController = Ember.ArrayController.extend
  sortProperties: ['idx']
  model:(-> Buzz.QueuedEpisode.find()).property('Buzz.QueuedEpisode')

  queued_episodes: (->
    this.get('model').sortBy('idx')
  ).property('model', 'model.@each', 'model.@each.idx')

  current_episode: (->
    this.get('queued_episodes.firstObject.episode')
  ).property('queued_episodes.firstObject.episode')


  is_enqueued: (episode_id) ->
    this.get('model').mapProperty('episode.id').contains(episode_id)

  dequeue: (episode) ->
    queued_episode = this.get('model').find (qe) ->
      qe.get('episode') == episode

    queued_episode.deleteRecord()
    queued_episode.save()

  enqueue: (episode) ->
    console.log episode
    queued_episode = Buzz.QueuedEpisode.createRecord episode: episode
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
