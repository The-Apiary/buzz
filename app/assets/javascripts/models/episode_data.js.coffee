Buzz.EpisodeData = DS.Model.extend
  is_played:        DS.attr 'boolean'
  current_position: DS.attr 'number'
  episode:          DS.belongsTo 'Buzz.Episode', async: true

  save_current_position: ->
    base_url = Buzz.Adapter.buildURL('episode_data', this.id)
    data = current_position: this.get('current_position')
    $.post([base_url,'watched'].join('/'), data)

