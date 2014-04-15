# TODO: Should this function be here?

Buzz.Episode = DS.Model.extend
  title:            DS.attr 'string'
  link_url:         DS.attr 'string'
  description:      DS.attr 'string'
  audio_url:        DS.attr 'string'
  publication_date: DS.attr 'date'
  duration:         DS.attr 'number'
  current_position: DS.attr 'number'
  is_played:        DS.attr 'boolean'
  podcast:          DS.belongsTo 'Buzz.Podcast', async: true

  # Set episode to unplayed state.
  reset: ->
    data = { current_position: 0, is_played: false }
    options = { throttled: false }

    update_episode_data data, options

  update_current_position: (cur_pos, options) ->
    this.update_episode_data({current_position: cur_pos}, options)

  update_is_played: (is_played, options) ->
    this.update_episode_data({is_played: is_played}, options)

  update_episode_data: (data, options) ->
    # Establish default options
    options ||= {}
    _.defaults(options, {throttled: true, timeout: 10000})

    _.each data, (value, key) =>
      this.set key, value

    base_url = Buzz.Adapter.buildURL('episode', this.id)
    url = [base_url, 'data'].join '/'

    args = {url: url, data: data, type: 'POST'}
    if options.throttled
      Ember.run.throttle $, 'ajax', args, options.timeout
    else
      $.ajax(args)


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
