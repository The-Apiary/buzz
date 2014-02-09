# for more details see: http://emberjs.com/guides/models/defining-models/

Buzz.Podcast = DS.Model.extend
  title: DS.attr 'string'
  image_url: DS.attr 'string'
  feed_url: DS.attr 'string'
  episodes: DS.hasMany 'Buzz.Episode', async: true

  unsubscribe: ->
    base_url = Buzz.Adapter.buildURL('podcast', this.id)
    console.log base_url
    $.post [base_url,'unsubscribe'].join('/')
