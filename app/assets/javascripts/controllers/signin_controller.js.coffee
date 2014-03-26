Buzz.SigninController = Ember.ObjectController.extend
  anon_id: null
  error: null

  feedback: (->
    if this.get 'error'
      return 'has-feedback has-error'
    else
      return ''
  ).property('error')

  actions:
    signin: ->
      console.log this.get 'anon_id'
      $.ajax(
        url: '/signin.json'
        data: { id_hash: this.get 'anon_id' }
      ).then(
        (data) => window.location.reload(),
        (data) => this.set 'error', $.parseJSON(data.responseText).error
      )
