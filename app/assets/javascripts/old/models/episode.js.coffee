# TODO: Should this function be here?

Buzz.Episode = DS.Model.extend
  title:               DS.attr 'string'
  link_url:            DS.attr 'string'
  description:         DS.attr 'string'
  audio_url:           DS.attr 'string'
  episode_type:        DS.attr 'string'
  publication_date:    DS.attr 'date'
  duration:            DS.attr 'number'
  last_listened_at:    DS.attr 'date'

  # ed_* values should not be used in the ui, they are proxied without the
  # ed_ prefix. See the note for cached_attribute
  ed_current_position: DS.attr 'number'
  ed_is_played:        DS.attr 'boolean'
  podcast:             DS.belongsTo 'podcast', async: true

  # Set episode to unplayed state.
  reset: ->
    this.set('current_position', 0)
    data = { current_position: 0 }
    options = { throttled: false }

    this.update_episode_data data, options

  # Used to implement attributes that can be changed serverside
  # without setting the state to changed.
  #
  # Some values, namely is_played and current_position, are changed often
  # and without saving to the database. A call that would reload an episode
  # after the position has changed would error because the state is
  # uncommited. The error is avoided by preserving the origional attributes
  # and changing these values. See also update_episode_data
  cached_attribute: (key, value) ->
    if value != undefined
      # If a value is passed set the cached attribute to that value
      this["cached_#{key}"] = value
    else
      # If no value is passed return the cached value, if cache isn't full
      # initialize it to the real attribute value.
      this["cached_#{key}"] || this["cached_#{key}"] = this.get("ed_#{key}")

    this["cached_#{key}"]

  current_position: ( (key, value) ->
    this.cached_attribute(key, value)
  ).property('ed_current_position')

  is_played: ( (key, value) ->
    this.cached_attribute(key, value)
  ).property('ed_is_played')



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

    base_url = this.store.adapterFor('episode').buildURL('episode', this.id)

    url = [base_url, 'data'].join '/'

    args = {url: url, data: data, type: 'POST'}
    if options.throttled
      Ember.run.throttle $, 'ajax', args, options.timeout
    else
      $.ajax(args)


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
