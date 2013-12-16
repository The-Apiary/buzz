Buzz.QueueController = Ember.ArrayController.extend
  model: []
  actions:
    dequeue: () ->
      this.shiftObject()
