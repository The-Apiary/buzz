Buzz.QueuedEpisode = DS.Model.extend
  episode: DS.belongsTo 'Buzz.Episode', async: true
