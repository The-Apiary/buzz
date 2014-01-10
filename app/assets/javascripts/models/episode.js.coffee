# TODO: Should this function be here?

Buzz.Episode = DS.Model.extend
  title:            DS.attr 'string'
  link_url:         DS.attr 'string'
  description:      DS.attr 'string'
  audio_url:        DS.attr 'string'
  publication_date: DS.attr 'date'
  duration:         DS.attr 'number'
  podcast:          DS.belongsTo 'Buzz.Podcast', async: true
  episode_data:     DS.belongsTo 'Buzz.EpisodeData', async: true

  create_or_update: (key, value) ->
    episode_data = this.get('episode_data')

    if episode_data
    # Update episode_data if it exists
      episode_data.set(key, value)
      Ember.run.throttle this, 'save_episode_data', 10000
    else
    # Create episode_data if it doesn't exist
      episode_data = Buzz.EpisodeData.createRecord(episode: this)
      episode_data.set(key, value)
      episode_data.save()

    return episode_data.get(key)

  save_episode_data: () ->
    this.get('episode_data').save()

  is_played: ( (key, is_played) ->
    # Setter
    if (is_played != undefined)
      return this.create_or_update(key, is_played)
    # Getter
    else
      return this.get('episode_data.is_played') || false
  ).property('episode_data.is_played')

  current_position: ( (key, current_position) ->
    # Setter
    if (current_position != undefined)
      return this.create_or_update(key, current_position)
    # Getter
    else
      return this.get('episode_data.current_position') || 0
  ).property('episode_data.current_position')
