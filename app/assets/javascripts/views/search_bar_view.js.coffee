Buzz.SearchBarView = Ember.View.extend
  templateName: 'search_bar'

  didInsertElement: () ->
    # Instantiate the bloodhound suggestion engine
    numbers = new Bloodhound
        datumTokenizer: (d) ->Bloodhound.tokenizers.whitespace(d.title)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/api/v1/search.json?q=%QUERY'

    # Initialize the bloodhound suggestion engine
    numbers.initialize()

    # describe template strings here
    templates =
      header:
        '''
        <div class="tt-header">
          <a href="#/search/{{query}}">
            <p>Search for {{query}}</p>
          </a>
        </div>
        '''
      # FIXME: This is bad.
      # Change the <a href="..."> to {{#link-to}}
      # All of these blocks should be declaired as templates,
      # and compiled with ember's handlebars.
      suggestion:
        '''
        <p>
          <a href="#/podcasts/{{id}}">
            <img src="{{image_url}}"></img>
            <strong>{{title}}</strong>
          </a>
        </p>
        '''
      empty:
        '''
        <div class="tt-no-results">
          <p>No Results</p>
        </div>
        '''

    # Compile templates
    _(templates).each (string, key, obj) ->
      obj[key] = Handlebars.compile string

    # instantiate the typeahead UI
    this.$('.typeahead').typeahead(null, {
        displayKey: 'title',
        source: numbers.ttAdapter()
        templates: templates
    });

  willDestroyElement: () ->
    # Typeahead input element
    this.$('.typeahead').typeahead('destroy')
