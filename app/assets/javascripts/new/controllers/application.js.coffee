Buzz.ApplicationController = Ember.ObjectController.extend
  # I'm not really sure how to handle binding data to css styles
  # so I'm binding to the whole style attribute.
  #
  # This function translates a javascript dictionary to a style string.
  now_playing: 1
  show_now_playing: (->
    "flex-grow: #{@get 'now_playing'};"
  ).property('now_playing');

  browse: 0
  show_browse: (->
    "flex-grow: #{@get 'browse'};"
  ).property('browse');

  queue: 0
  show_queue: (->
    "flex-grow: #{@get 'queue'};"
  ).property('queue');

  actions:
    show_pane: (pane) ->
      console.log pane
      _.each ["now_playing", "browse", "queue"], (p) =>
        @set p, if p == pane then 1 else 0

      return false
