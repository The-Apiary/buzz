Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  enqueued:  (->
    this.get('controllers.queue').contains(this.get('model'))
  ).property('controllers.queue.@each.model')
  actions:
    enqueue: () ->
      this.get('controllers.queue').addObject(this.get('model'))
    dequeue: () ->
      this.get('controllers.queue').removeObject(this.get('model'))
