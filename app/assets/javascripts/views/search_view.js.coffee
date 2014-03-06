Buzz.SearchView = Ember.View.extend
  templateName: 'search'

  didInsertElement: () ->
    console.log('didInsertElement')
    # Instantiate the bloodhound suggestion engine
    numbers = new Bloodhound
        datumTokenizer: (d) ->Bloodhound.tokenizers.whitespace(d.title)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/api/v1/search.json?q=%QUERY'

    # Initialize the bloodhound suggestion engine
    numbers.initialize()

    # instantiate the typeahead UI
    this.$('.typeahead').typeahead(null, {
        displayKey: 'title',
        source: numbers.ttAdapter()
        templates:
          header: Handlebars.compile '<div class="tt-header"><p>Search for {{query}}</p></div>'
          suggestion: Handlebars.compile '<p><img src="{{image_url}}"></img><strong>{{title}}</strong></p>'
          empty: Handlebars.compile '<p>No Results</p>'
    });

  willDestroyElement: () ->
    console.log('willDestroyElement')
    # Typeahead input element
    this.$('.typeahead').typeahead('destroy')
