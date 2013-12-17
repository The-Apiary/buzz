Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  enqueue: (episode) ->
    if ! this.enqueued(episode)
      # TODO: make this more abastract
      queued_episode = Buzz.QueuedEpisode.createRecordFromEpisode episode

      queued_episode.save()
  remove: (episode) ->
    queued_episode = Buzz.QueuedEpisode.find(episode.id)
    queued_episode.deleteRecord()
    queued_episode.get('store').commit()
  enqueued: (episode) ->
    this.get('queue').mapProperty('id').contains(episode.id)

  actions:
    dequeue: () ->
      queued_episode = this.get('queue').shiftObject()
      queued_episode.deleteRecord()
      queued_episode.get('store').commit()
