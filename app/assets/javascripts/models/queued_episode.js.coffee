Buzz.QueuedEpisode = DS.Model.extend
  idx:            DS.attr 'number'
  before_episode: DS.attr 'number'
  after_episode:  DS.attr 'number'
  unshift:        DS.attr 'boolean'
  episode:        DS.belongsTo 'episode'
