Buzz.QueuedEpisodeView = Ember.View.extend
  templateName: 'queued_episode'
  didInsertElement: () ->
    this.$('.drop-target').bind 'dragenter', ->
      this.parentNode.classList.add('over')

    this.$('.drop-target').bind 'dragleave', ->
      this.parentNode.classList.remove('over')

  willDestroyElement: () ->
    console.log 'remove'

