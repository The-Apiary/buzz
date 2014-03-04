#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require turbolinks
#= require_self
#= require buzz

#= require bootstrap

# for more details see: http:#emberjs.com/guides/application/
window.Buzz = Ember.Application.create()

#= require_tree .
$ ->
  token = $('meta[name="csrf-token"]').attr('content')
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    xhr.setRequestHeader('X-CSRF-Token', token)
