Buzz.Subscription = DS.Model.extend
  podcast: DS.belongsTo 'Buzz.Podcast', async: true
  titleBinding: 'podcast.title'
  image_urlBinding: 'podcast.image_url'
  feed_urlBinding: 'podcast.feed_url'
  episodesBinding: 'podcast.episodes'
