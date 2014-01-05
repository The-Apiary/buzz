Buzz.Episode = DS.Model.extend
  title:            DS.attr 'string'
  link_url:         DS.attr 'string'
  description:      DS.attr 'string'
  audio_url:        DS.attr 'string'
  publication_date: DS.attr 'date'
  duration:         DS.attr 'number'
  podcast:          DS.belongsTo 'Buzz.Podcast', async: true
  episode_data:     DS.belongsTo 'Buzz.EpisodeData', async: true

  is_played: ( ->
    this.get('episode_data.is_played')
  ).property('episode_data', 'episode_data.is_played')
  current_position: ( ->
    this.get('episode_data.current_position')
  ).property('episode_data', 'episode_data.current_position')
