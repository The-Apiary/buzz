Buzz.EpisodeData = DS.Model.extend
  is_played:        DS.attr 'boolean'
  current_position: DS.attr 'number'
  episode:          DS.belongsTo 'Buzz.Episode', async: true
