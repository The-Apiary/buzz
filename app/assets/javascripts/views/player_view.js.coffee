Buzz.PlayerView = Ember.View.extend
  templateName: 'player'
  didInsertElement: () ->
    self = this
    player = this.$('audio')[0]
    player.addEventListener 'ended', (event) ->
      console.log "episode ended"
      self.get('controller').send('dequeue')
  willDestroyElement: () ->
    player = this.$('audio')[0]
    player.removeEventListener 'ended'

