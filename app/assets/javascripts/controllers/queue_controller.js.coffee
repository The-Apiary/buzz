Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  enqueue: (episode) ->
    if ! this.enqueued(episode)
      # TODO: make this more abastract
      queued_episode = Buzz.QueuedEpisode.createRecord
        title: episode.get 'title'
        link_url: episode.get 'link_url'
        description: episode.get 'description'
        audio_url: episode.get 'audio_url'
        title: episode.get 'title'
        podcast: episode.get 'podcast'
        id: episode.get 'id'

      queued_episode.save()
  remove: (episode) ->
    queued_episode = Buzz.QueuedEpisode.find(episode.id)
    queued_episode.deleteRecord()
    queued_episode.get('store').commit()
    #this.get('queue').removeObject(queued_episode)
  enqueued: (episode) ->
    this.get('queue').mapProperty('id').contains(episode.id)

  actions:
    dequeue: () ->
      queued_episode = this.get('queue').shiftObject()
      queued_episode.deleteRecord()
      queued_episode.get('store').commit()
