Buzz.IndexController = Ember.ObjectController.extend
  # This might be really slow.
  displayed_episodes: (->
    self = this
    filter = this.get('model.episodes')

    # Is played filter
    filter = filter.filterBy('is_played', false)

    # Podcast filter
    if self.get('filteredPodcast')
      filter = filter.filter (item, index, enumerable) ->
        item.get('podcast') == self.get('filteredPodcast')

    # Length filter
    filter = filter.slice(0,100)
    return filter
  ).property('model.episodes.@each.is_played', 'filteredPodcast')

  actions:
    show_all: ->
      this.set 'filteredPodcast', undefined
    show: (podcast)->
      this.set 'filteredPodcast', podcast
