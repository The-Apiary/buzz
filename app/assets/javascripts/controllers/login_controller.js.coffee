Buzz.LoginController = Ember.ObjectController.extend
  anon_id: null
  actions:
    login: ->
      console.log this.get 'anon_id'
