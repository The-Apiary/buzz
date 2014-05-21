#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./components
#= require_tree ./views
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self

# Shamelessly taken from
# http://stackoverflow.com/questions/12168570/how-to-represent-arrays-within-ember-data-models/13884238#13884238
DS.JSONTransforms.array =

  serialize: (jsonData)->
    if Em.typeOf(jsonData) is 'array' then jsonData else []

  deserialize: (externalData)->
    switch Em.typeOf(externalData)
      when 'array'  then return externalData
      when 'string' then return externalData.split(',').map((item)-> jQuery.trim(item))
      else               return []

##
# Sends events from @element to the @dispatcher, prefixed with @namespace
class Buzz.LocalEventDispatcher
  constructor: (@element, @dispatcher, @namespace) ->
    @dsp_events = {}

  ##
  # Returns the namespaced event name.
  event: (event) -> "#{@namespace}.#{event}"

  ##
  # Used in adding dispatched events NOTE: Private vars in coffeescript?
  meta_addDispatchedEvent: (event, message_cb, dispatch_cb) ->
    # dispatch a message when the audio element triggers an event.
    @element.addEventListener event, () ->
      message = if _.isFunction(message_cb) then message_cb() else {}
      dispatch_cb(message)

  ##
  # Send an event to the controller and the socket.
  addDispatchedEvent: (event, message_cb) ->
    @meta_addDispatchedEvent event, message_cb, (message) =>
      console.log "trigger #{@event(event)}"
      @dispatcher.trigger @event(event), message

  ##
  # Send an event to the controller and the socket.
  # Limit the number of events sent with Ember.run.throttle.
  #
  # Ember.run matches methods by the context and the name of the method
  # but not the arguments
  # passing `@dispatcher` and `trigger` as the context and method name
  # would throttle all events when instead I want to throttle each type of
  # event seperatly. A timeupdate event can immediatly follow a progress
  # event, but two progress events should be throttled.
  #
  # My solution is to dynamically add methods to the dsp_events hash.
  # The hash should be used as the context and the event name should be
  # the method name. Maybe there is a better way.
  addThrottledDispatchedEvent: (event, limit, message_cb) ->
    @dsp_events[event] ||= (message) =>
      @dispatcher.trigger @event(event), message
    @meta_addDispatchedEvent event, message_cb, (message) =>
      Ember.run.throttle @dsp_events, event, message, limit

class Buzz.RemoteEventListener
  constructor: (@controller, @channel, @namespace) ->

  ##
  # Returns the namespaced event name.
  event: (event) -> "#{@namespace}.#{event}"

  ##
  # Send messages to the controller when an event is received from the
  # socket.
  bind: (event) ->
    @channel.bind @event(event), (message) =>
      @controller.send 'event', event, message
