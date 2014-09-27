Buzz.Category = DS.Model.extend
  name:    DS.attr 'string'
  podcasts: DS.hasMany 'podcast', async: true

