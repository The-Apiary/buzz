#= require_self
#= require ./buzz

# for more details see: http:#emberjs.com/guides/application/
window.Buzz = Ember.Application.create({
  Resolver: Ember.DefaultResolver.extend({
  # Redirect templates to old subfolder.
  resolveTemplate: (name) ->
    name.fullNameWithoutType = 'old.' + name.fullNameWithoutType
    return this._super(name)
  })
})

Handlebars.registerHelper 'escape', (value) ->
  return escape(value)

Ember.Handlebars.registerHelper 'link-to-li', (routeName, options) ->
  o_options = _(options).clone()
  o_options.hash = _(options.hash).clone()

  o_options.hash.eventName = 'dummy'
  o_options.hash.tagName = 'li'
  o_options.hash.href = false
  o_options.fn = (c) -> Ember.Handlebars.helpers['link-to'].apply(c, [routeName, options])

  Ember.Handlebars.helpers['link-to'].apply(this, [routeName, o_options])

# UGLY: Facebook login redirects to /#_=_ (why? IDK), this will handle that
# by directing back to /
window.location.hash = "" if (window.location.hash == "#_=_")

Ember.Handlebars.registerBoundHelper 'pretty-time', (time) ->
  return '--:--' unless time

  # Put this somewhere else
  hours   = Math.floor time / (60 * 60)
  divisor_for_minutes = time % (60 * 60)
  minutes = Math.floor divisor_for_minutes / 60
  divisor_for_seconds = divisor_for_minutes % 60
  seconds = Math.ceil divisor_for_seconds

  # Convert to strings
  pad = (n) ->
    n = n + ''

    # dumb, TODO better way to do this?
    while n.length < 2
      n = '0' + n
    return n

  # x:xx:xx if hours present, xx:xx otherwise
  time = [minutes, seconds].map(pad)
  time.unshift hours if hours != 0
  time.join(':')

$ ->
  # Ember wasn't sending the csrf token, so rails was erroring with InvalidAccessToken
  token = $('meta[name="csrf-token"]').attr('content')
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    xhr.setRequestHeader('X-CSRF-Token', token)
