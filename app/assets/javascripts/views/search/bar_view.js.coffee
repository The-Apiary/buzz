Buzz.SearchBarView = Ember.View.extend
  templateName: 'search_bar'

  didInsertElement: () ->
    self = this
    # The search dropdown is focused
    this.$('.search').on 'focus', ->
      self.set('controller.focus_changed', true)

    this.$('.search').on 'mouseenter', ->
      self.set('controller.focus_changed', true)

    this.$('.search-dropdown-menu').on 'mouseenter', ->
      self.set('controller.focus_changed', true)

    # The search dropdown is not focused
    # These should be the opposites of the above
    this.$('.search').on 'blur', ->
      self.set('controller.focus_changed', true)

    this.$('.search').on 'mouseleave', ->
      self.set('controller.focus_changed', false)

    this.$('.search-dropdown-menu').on 'mouseleave', ->
      self.set('controller.focus_changed', false)
  willDestroyElement: () ->
    # Typeahead input element
    this.$('.search-dropdown-menu').hide()
