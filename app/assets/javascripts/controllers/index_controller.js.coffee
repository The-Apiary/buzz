Buzz.IndexController = Ember.ArrayController.extend
  currentEpisodeBinding: 'model.firstObject.episode'

  actions:
    markPlayed: () ->
      currentEpisode = this.get 'currentEpisode'

      # Mark the episode as played
      currentEpisode.set 'is_played', true
      currentEpisode.save()

      # Remove the episode from the queue
      this.remove currentEpisode

    setCurrentPosition: (position) ->
      this.get('currentEpisode').set('current_position', position)

    setDuration: (duration) ->
      currentEpisode = this.get('currentEpisode')
      if currentEpisode.get('duration') != duration
        currentEpisode.set('duration', duration)
        currentEpisode.save()
