Buzz.EpisodeListController = Ember.ArrayController.extend
  show_played_options: [ 'Show Unplayed', 'Show Played', 'Show Both' ]

  played_filter: 'Show Unplayed'

  type_options: [ 'Normal', 'Serial', 'News' ]

  type: 'Normal'

  filtered_episodes: (->
    if this.get('played_filter') == 'Show Unplayed'
      this.get('model').filter (episode) -> not episode.get 'is_played'
    else if this.get('played_filter') == 'Show Played'
      this.get('model').filter (episode) -> episode.get 'is_played'
    else
      this.get('model')
  ).property('model', 'model.@each', 'played_filter')

  episodes: (->
    if this.get('type') == 'Normal'
      this.get('filtered_episodes').sortBy('publication_date').reverseObjects()
    else if this.get('type') == 'Serial'
      this.get('filtered_episodes').sortBy('publication_date')
    else if this.get('type') == 'News'
      this.get('filtered_episodes').filter (episode) ->
        one_week_in_ms = 1000 * 60 * 60 * 24 * 7
        episode.get('publication_date').getTime() > Date.now() - one_week_in_ms
  ).property('filtered_episodes', 'filtered_episodes.@each', 'type')
