# for more details see: http://emberjs.com/guides/models/defining-models/

Buzz.Podcast = DS.Model.extend
  title:         DS.attr 'string'
  description:   DS.attr 'string'
  image_url:     DS.attr 'string'
  link_url:      DS.attr 'string'
  feed_url:      DS.attr 'string'
  categories:    DS.attr 'array'
  episodes:      DS.hasMany 'episode', async: true
  subscription:  DS.belongsTo 'subscription', async:true
  subscriptions_count: DS.attr 'number'
