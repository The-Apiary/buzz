Buzz.SearchBarView = Ember.View.extend
  templateName: 'search_bar'

  didInsertElement: () ->
    # Instantiate the bloodhound suggestion engine
    podcasts = new Bloodhound
        datumTokenizer: (d) ->Bloodhound.tokenizers.whitespace(d.title)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/api/v1/podcasts/search.json?q=%QUERY'

    episodes = new Bloodhound
        datumTokenizer: (d) ->Bloodhound.tokenizers.whitespace(d.title)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/api/v1/episodes/search.json?q=%QUERY'

    # Initialize the bloodhound suggestion engine
    podcasts.initialize()
    episodes.initialize()

    # Describe podcast template strings here
    podcast_templates =
      header:
        '''
        Podcasts
        '''
      suggestion:
        '''
        <div class='media'>
          <div class='pull-left'>
            <img src="{{image_url}}"></img>
          </div>
          <div class='media-body'>
            <h5 class='media-heading'>
              <a href='#/podcasts/{{id}}'>{{title}}</a>
            </h5>
            <p class='small'>
              Podcast
            </p>
          </div>
        </div>
        '''
      empty:
        '''
        <div class="tt-no-results">
          <p>No Podcasts</p>
        </div>
        '''
    # Describe episode template strings here
    episode_templates =
      header:
        '''
        Episodes
        '''
      suggestion:
        '''
        <div class='media'>
          <div class='pull-left'>
            <img src="{{image_url}}"></img>
          </div>
          <div class='media-body'>
            <h5 class='media-heading'>
              <a href='#/episodes/{{id}}'>{{title}}</a>
            </h5>
            <p class='small'>
              Podcast: <a href='#/podcasts/{{podcast_id}}'>{{podcast_title}}</a>
            </p>
          </div>
        </div>
        '''
      empty:
        '''
        <div class="tt-no-results">
          <p>No Episodes</p>
        </div>
        '''

    # Compile templates
    _(podcast_templates).each (string, key, obj) ->
      obj[key] = Handlebars.compile string
    _(episode_templates).each (string, key, obj) ->
      obj[key] = Handlebars.compile string

    # instantiate the typeahead UI
    this.$('.typeahead').typeahead(
      {
        minLength: 3,
        highlight: true
      },
      {
        name: 'podcasts',
        displayKey: 'title',
        source: podcasts.ttAdapter()
        templates: podcast_templates
      },
      {
        name: 'episodes',
        displayKey: 'title',
        source: episodes.ttAdapter()
        templates: episode_templates
      },
    )


  willDestroyElement: () ->
    # Typeahead input element
    this.$('.typeahead').typeahead('destroy')
