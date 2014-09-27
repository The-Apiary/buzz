#= require_self
#= require ./buzz

# for more details see: http:#emberjs.com/guides/application/
window.Buzz = Ember.Application.create({
  Resolver: Ember.DefaultResolver.extend({
  # Redirect templates to old subfolder.
  resolveTemplate: (name) ->
    name.fullNameWithoutType = 'new.' + name.fullNameWithoutType
    return this._super(name)
  })
})


