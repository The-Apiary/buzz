Buzz.ApplicationController = Ember.ObjectController.extend
  selected_pane: 'now_playing'

  now_playing_style: (->
    @_pane_class 'now_playing'
  ).property('selected_pane')

  browse_style: (->
    @_pane_class 'browse'
  ).property('selected_pane')

  queue_style: (->
    @_pane_class 'queue'
  ).property('selected_pane')

  # Returns the passed pane's style.
  _pane_class: (pane) ->
    "selected-pane" if @get('selected_pane') == pane

  actions:
    show_pane: (pane) ->
      @set 'selected_pane', pane
      return false
