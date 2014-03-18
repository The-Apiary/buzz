Buzz.Subscription = DS.Model.extend
  podcast: DS.belongsTo 'Buzz.Podcast', async: true
  subscription_type: DS.attr 'string'
  titleBinding: 'podcast.title'
  image_urlBinding: 'podcast.image_url'
  feed_urlBinding: 'podcast.feed_url'
  episodesBinding: 'podcast.episodes'
