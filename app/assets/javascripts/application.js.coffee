#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require turbolinks
#= require typeahead
#= require underscore
#= require_self
#= require buzz

#= require bootstrap

# for more details see: http:#emberjs.com/guides/application/
window.Buzz = Ember.Application.create()

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

$ ->
  # Ember wasn't sending the csrf token, so rails was erroring with InvalidAccessToken
  token = $('meta[name="csrf-token"]').attr('content')
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    xhr.setRequestHeader('X-CSRF-Token', token)
