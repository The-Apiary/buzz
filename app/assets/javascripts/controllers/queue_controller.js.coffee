Buzz.QueueController = Ember.ArrayController.extend

  queued_episodes: (->
    Buzz.QueuedEpisode.find()
  ).property('Buzz.QueuedEpisode')

  current_episode: (->
    console.log this.get('queued_episodes.length')
    this.get('queued_episodes.firstObject.episode')
  ).property('queued_episodes', 'queued_episodes.length')

  is_enqueued: (episode) ->
    this.get('queued_episodes').mapProperty('episode').contains(episode)

  dequeue: (episode) ->
    queued_episode = this.get('queued_episodes').find (qe) ->
      qe.get('episode') == episode

    queued_episode.deleteRecord()
    queued_episode.save()

  enqueue: (episode) ->
    queued_episode = Buzz.QueuedEpisode.createRecord episode: episode
    queued_episode.save()

  actions:
      markPlayed: () ->
        current_episode = this.get 'current_episode'

        # Mark the episode as played
        current_episode.set 'is_played', true
        current_episode.save()

        # Delete the queued episode, removing it from the queue
        queued_episode = this.get('queued_episodes.firstObject')
        queued_episode.deleteRecord()
        queued_episode.save()

      setCurrentPosition: (position) ->
        this.get('current_episode').set('current_position', position)

      setDuration: (duration) ->
        current_episode = this.get('current_episode')
        if current_episode.get('duration') != duration
          current_episode.set('duration', duration)
          current_episode.save()
