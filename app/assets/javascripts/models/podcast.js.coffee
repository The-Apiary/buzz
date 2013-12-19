# for more details see: http://emberjs.com/guides/models/defining-models/

Buzz.Podcast = DS.Model.extend
  title: DS.attr 'string'
  image_url: DS.attr 'string'
  feed_url: DS.attr 'string'
  episodes: DS.hasMany 'Buzz.Episode', async: true

  episode_count: (->
    this.get 'episodes.length'
  ).property('episodes.length')
