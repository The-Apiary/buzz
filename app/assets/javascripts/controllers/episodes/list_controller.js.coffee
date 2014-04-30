Buzz.EpisodesListController = Ember.ArrayController.extend
  show_played_options: [ 'Show Unplayed', 'Show Played', 'Show Both' ]

  played_filter: 'Show Unplayed'

  episodes: (->
    if this.get('played_filter') == 'Show Unplayed'
      this.get('model').filter (episode) -> not episode.get 'is_played'
    else if this.get('played_filter') == 'Show Played'
      this.get('model').filter (episode) -> episode.get 'is_played'
    else
      this.get('model')
  ).property('model', 'model.@each.is_played', 'played_filter')
