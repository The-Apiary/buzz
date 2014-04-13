Buzz.PlayerController = Ember.ObjectController.extend
  needs: 'queue'
  is_playing: true
  player: null

  actions:
    play: ->
      this.get('player').play()
    pause: ->
      this.get('player').pause()
    skip: ->
      this.get('controllers.queue').remove(this.get 'model')
    mute: ->
      this.get('player').muted = true
    unmute: ->
      this.get('player').muted = false
