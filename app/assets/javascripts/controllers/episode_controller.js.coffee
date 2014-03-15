Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  is_enqueued: (->
    this.get('controllers.queue').is_enqueued(this.get('id'))
  ).property('controllers.queue.queued_episodes.length')
  actions:
    dequeue: (episode) ->
      this.get('controllers.queue').dequeue(episode)
    enqueue: (episode) ->
      this.get('controllers.queue').enqueue(episode)
