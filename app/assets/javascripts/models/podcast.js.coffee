# for more details see: http://emberjs.com/guides/models/defining-models/

Buzz.Podcast = DS.Model.extend
  title: DS.attr 'string'
  image_url: DS.attr 'string'
  feed_url: DS.attr 'string'
  episodes: DS.hasMany 'Buzz.Episode', async: true

  unsubscribe: ->
    # unsubscribe from the podcast
    base_url = Buzz.Adapter.buildURL('podcast', this.id)
    $.post [base_url,'unsubscribe'].join('/')
