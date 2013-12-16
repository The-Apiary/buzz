Buzz.QueueController = Ember.ArrayController.extend
  actions:
    dequeue: () ->
      this.shiftObject()
