#:: Podcasts New Controller
Buzz.PodcastsNewController = Ember.ObjectController.extend
  feed_url: null
  errors: []

  feedback: (->
    if this.get('errors.length') > 0
      return 'has-feedback has-error'
    else
      return ''
  ).property('errors', 'errors.@each')

  actions:

    create: ->
      podcast = Buzz.Podcast.createRecord feed_url: this.get('feed_url')
      podcast.save().then(
        ( (podcast) => this.transitionToRoute('podcasts.show', podcast) ),
        ( (podcast) =>
          errors = _.chain(podcast.errors).map( (messages, attr) ->
            (messages).map (message) ->
              "#{attr} #{message}"
          ).flatten().value()

          this.set('errors', errors)
        )
      )

