Buzz.LoginController = Ember.ObjectController.extend
  anon_id: null
  error: null

  feedback: (->
    if this.get 'error'
      return 'has-feedback has-error'
    else
      return ''
  ).property('error')

  actions:
    login: ->
      console.log this.get 'anon_id'
      $.ajax(
        url: '/login'
        data: { id_hash: this.get 'anon_id' }
        type: 'PUT'
      ).then(
        (data) => window.location.reload(),
        (data) => this.set 'error', $.parseJSON(data.responseText).error
      )
