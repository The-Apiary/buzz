Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'

  duration: (->
    duration = this.get('model.duration')
    [Math.floor(duration / 60), Math.floor(duration % 60)].join(':')
  ).property('model.duration')

  currentPosition: (->
    currentPosition = this.get('model.currentPosition')
    [Math.floor(currentPosition / 60), Math.floor(currentPosition % 60)].join(':')
  ).property('model.currentPosition')

  enqueued:  (->
    this.get('queue').enqueued(this.get('model'))
  ).property('queue.queue.length')

  actions:
    enqueue: () ->
      this.get('queue').enqueue(this.get('model'))
    remove: () ->
      this.get('queue').remove(this.get('model'))
