Buzz.Episode = DS.Model.extend
  title:            DS.attr 'string'
  link_url:         DS.attr 'string'
  description:      DS.attr 'string'
  audio_url:        DS.attr 'string'
  publication_date: DS.attr 'date'
  duration:         DS.attr 'number'
  is_played: DS.attr 'boolean'
  current_position: DS.attr 'number'
  podcast:          DS.belongsTo 'Buzz.Podcast', async: true
