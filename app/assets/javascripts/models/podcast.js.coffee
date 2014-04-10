# for more details see: http://emberjs.com/guides/models/defining-models/

Buzz.Podcast = DS.Model.extend
  title:         DS.attr 'string'
  description:   DS.attr 'string'
  image_url:     DS.attr 'string'
  link_url:      DS.attr 'string'
  feed_url:      DS.attr 'string'
  categories:    DS.attr 'array'
  episodes:      DS.hasMany 'Buzz.Episode', async: true
  subscription:  DS.belongsTo 'Buzz.Subscription', async:true
  subscriptions_count: DS.attr 'number'
