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

  # Set episode to unplayed state.
  reset: ->
    episode_data = this.get('episode_data')
    episode_data.set('current_position', 0)
    episode_data.set('is_played', 0)
    episode_data.save()


  # Update this episodes user data,
  # or create the model if it doesn't exist.
  create_or_update_episode_data: (key, value) ->
    episode_data = this.get('episode_data')

    if episode_data
      # Episode data exists, so update the key
      episode_data.set(key, value)
      # Only save every 10,000 microseconds
      episode_data.direct_update(10000)

    else
      # Episode data doesn't exist, so create it.
      hash = episode: this
      hash[key] = value
      episode_data = Buzz.EpisodeData.createRecord hash
      this.set('episode_data', episode_data)
      episode_data.set(key, value)
      episode_data.save()

    return episode_data.get(key)

  is_played: ( (key, is_played) ->
    # Setter
    if (is_played != undefined)
      return this.create_or_update_episode_data(key, is_played)
    # Getter
    else
      return this.get('episode_data.is_played') || false
  ).property('episode_data.is_played')

  current_position: ( (key, current_position) ->
    # Setter
    if (current_position != undefined)
      return this.create_or_update_episode_data(key, current_position)
    # Getter
    else
      return this.get('episode_data.current_position') || 0
  ).property('episode_data.current_position')

  pretify_time: (duration) ->
    return '--:--' unless duration

    # Put this somewhere else
    hours   = Math.floor duration / (60 * 60)
    divisor_for_minutes = duration % (60 * 60)
    minutes = Math.floor divisor_for_minutes / 60
    divisor_for_seconds = divisor_for_minutes % 60
    seconds = Math.ceil divisor_for_seconds

    # Convert to strings
    pad = (n) ->
      n = n + ''

      # dumb, TODO better way to do this?
      while n.length < 2
        n = '0' + n
      return n

    # xx:xx:xx if hours present, xx:xx otherwise
    time = [minutes, seconds]
    time.unshift hours if hours != 0

    time.map(pad).join(':')

  pretty_position: (->
    duration = this.get 'current_position'
    this.pretify_time(duration)
  ).property('current_position')

  pretty_duration: (->
    duration = this.get 'duration'
    this.pretify_time(duration)
  ).property('duration')

  percent_listened: (->
    duration = this.get 'duration'
    current_position = this.get 'current_position'

    if duration == 0 || current_position == 0
      return 0
    else
      return current_position / duration * 100
  ).property('duration', 'current_position')

  percent_listened_width: (->
    return "width: #{this.get('percent_listened')}%;"
  ).property('percent_listened')

  reset_enabled: (->
    'disabled' if this.get('current_position') == 0
  ).property('current_position')

