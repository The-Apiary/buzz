Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'
  enqueued:  (->
    this.get('queue').enqueued(this.get('model'))
  ).property('queue.queue.length')

  actions:
    enqueue: () ->
      this.get('queue').enqueue(this.get('model'))
    remove: () ->
      this.get('queue').remove(this.get('model'))
