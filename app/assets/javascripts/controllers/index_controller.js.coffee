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
  ).property('model.episodes', 'model.episodes.@each.is_played', 'selected_podcast', 'show_played')

  actions:
    toggle_show_played: ->
      console.log('show played')
      console.log this.toggleProperty('show_played')
      return null;

    unselect_podcast: ->
      this.set 'selected_podcast', undefined

    select_podcast: (podcast) ->
      this.set 'selected_podcast', podcast

    unsubscribe: (subscription) ->
      # Remove this subscription from the list of subscriptions
      this.get('model.subscriptions').removeObject(subscription)

      # Remove this podcasts episodes from the list of episodes
      podcast = subscription.get 'podcast'
      this.set('model.episodes', this.get('model.episodes').filter (episode) ->
        episode.get('podcast') != podcast
      )
