Buzz.IndexController = Ember.ObjectController.extend
  # If a podcast is selected only show podcasts
  # of that episode.
  selected_podcast: undefined

  # If show played is true played and unplayed episodes should
  # be displayed
  show_played: false

  # TODO: There might be a better way to handle this.
  displayed_episodes: (->
    self = this
    filter = this.get('model.episodes')

    filters =
      # True if show_played is true, or episodeis unplayed
      played: (item, index, enumerable) ->
        self.get('show_played') ||
        item.get('is_played') != true

      # True if selected_podcast is undefined, or episode belongs 
      # to selected_podcast
      selected_podcast: (item, index, enumerable) ->
        self.get('selected_podcast') == undefined ||
        item.get('podcast') == self.get('selected_podcast')

    filter = filter.filter (item, index, enumerable) ->
      filters.played(item, index, enumerable) &&
      filters.selected_podcast(item, index, enumerable)


    # Length filter
    filter = filter.slice(0,100)
    return filter
  ).property('model.episodes.@each.is_played', 'selected_podcast')

  actions:
    show_all: ->
      this.set 'selected_podcast', undefined
    show: (podcast)->
      this.set 'selected_podcast', podcast
