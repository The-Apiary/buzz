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

    # describe template strings here
    templates =
      header:
        '<div class="tt-header"><p>Search for {{query}}</p></div>'
      # NOTE: Change the <a href="..."> to {{#link-to}}
      suggestion:
        '<p><a href="#/podcasts/{{id}}"><img src="{{image_url}}"></img><strong>{{title}}</strong></a></p>'
      empty:
        '<p>No Results</p>'

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
    console.log('willDestroyElement')
    # Typeahead input element
    this.$('.typeahead').typeahead('destroy')
