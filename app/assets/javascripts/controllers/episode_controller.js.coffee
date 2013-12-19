Buzz.EpisodeController = Ember.ObjectController.extend
  needs: 'queue'
  queueBinding: 'controllers.queue'

  pretify_time: (duration) ->
    return '--:--' unless duration

    # Put this somewhere else
    hours = Math.floor duration / (60 * 60)
    divisor_for_minutes = duration % (60 * 60)
    minutes = Math.floor divisor_for_minutes / 60
    divisor_for_seconds = divisor_for_minutes % 60
    seconds = Math.ceil divisor_for_seconds

    # Convert to strings
    pad = (n) ->
      n = n + ''

      # dumb, TODO make this better for sses and gees
      while n.length < 2
        n = '0' + n
      return n

    # xx:xx:xx if hours present, xx:xx otherwise
    time = [minutes, seconds]
    time.push hours if hours != 0

    time.map(pad).join(':')

  pretty_position: (->
    duration = this.get 'model.current_position'
    this.pretify_time(duration)
  ).property('model.current_position')
  pretty_duration: (->
    duration = this.get 'model.duration'
    this.pretify_time(duration)
  ).property('model.duration')

  enqueued:  (->
    this.get('queue').enqueued(this.get('model'))
  ).property('queue.queue.length')

  actions:
    enqueue: () ->
      this.get('queue').enqueue(this.get('model'))
    remove: () ->
      this.get('queue').remove(this.get('model'))
