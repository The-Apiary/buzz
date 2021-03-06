Buzz.QueuedEpisodeView = Ember.View.extend
  templateName: 'queued_episode'
  dragging: null

  didInsertElement: () ->
    self = this

    #-- Drag start and end events

    this.$('.queued_episode[draggable=true]').bind 'dragstart', (e) ->
      this.style.opacity = '0.4'
      self.set 'dragging', true

      # Store the episode id in the drag event so it can be retreved in
      # the drop event.
      e.dataTransfer.setData('queued_episode_id', self.get('controller.model.id'))

    this.$('.queued_episode[draggable=true]').bind 'dragend', ->
      this.style.opacity = '1.0'
      self.set 'dragging', false

      $('.drop-target').each () ->
        this.parentNode.classList.remove('over')

    #-- Start request to move dragged episode before this episode
    this.$('.add-before').bind 'drop', (e) ->
      before_id = self.get('controller.model.episode.id')

      qe_id = e.dataTransfer.getData('queued_episode_id')
      self.controller.store.find('queued_episode', qe_id).then (qe) ->
        qe.set('before_episode', before_id)
        qe.set('idx', self.get('idx') - 0.5)
        qe.save()

    #-- Highlight drop areas.
    this.$('.drop-target').bind 'dragenter', (e) ->
      unless self.get 'dragging'
        this.parentNode.classList.add('over')

    this.$('.drop-target').bind 'dragleave', ->
      this.parentNode.classList.remove('over')

    #-- Prevent default action to allow drop
    this.$('.drop-target').bind 'dragover', (e) ->
      e.preventDefault()

