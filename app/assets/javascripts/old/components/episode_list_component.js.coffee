Buzz.EpisodeListComponent = Ember.Component.extend
  show_played_options: [ 'Show Unplayed', 'Show Played', 'Show Both' ]
  played_filter: 'Show Unplayed'

  filtered_episodes: (->
    if this.get('played_filter') == 'Show Unplayed'
      this.get('episodes').filter (episode) -> not episode.get 'is_played'
    else if this.get('played_filter') == 'Show Played'
      this.get('episodes').filter (episode) -> episode.get 'is_played'
    else
      this.get('episodes')
  ).property('episodes', 'episodes.@each.is_played', 'played_filter')
