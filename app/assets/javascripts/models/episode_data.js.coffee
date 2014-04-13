Buzz.EpisodeData = DS.Model.extend
  is_played:        DS.attr 'boolean'
  current_position: DS.attr 'number'
  episode:          DS.belongsTo 'Buzz.Episode', async: true

  # Save the record without using ember,
  # so the model isn't marked as dirty.
  direct_update: (timeout) ->
    if timeout > 0
      Ember.run.throttle this, 'unthrottled_direct_update', timeout
    else
      this.unthrottled_direct_update()

    # NOTE: [this](http://emberjs.com/api/data/classes/DS.RootState.html)
    # says that model.transitionTo should only be called from a state, but it's
    # a webpage, not a cop. I do what I want.
    #
    # If there is ever a bug anywhere in the application blame this.
    this.transitionTo('loaded.saved')

  unthrottled_direct_update: ->
    base_url = Buzz.Adapter.buildURL('episode_data', this.id)
    data = episode_data: this.serialize()
    console.log data
    $.ajax(url: base_url, data: data, type: 'PUT')
