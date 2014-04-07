Buzz.QueuedEpisode = DS.Model.extend
  idx:       DS.attr 'number'
  before_episode: DS.attr 'number'
  episode: DS.belongsTo 'Buzz.Episode', async: true
