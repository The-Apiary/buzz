#= require ./store
#= require_tree ./models
#= require_tree ./controllers
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
