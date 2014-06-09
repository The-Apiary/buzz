#Buzz.EpisodeController = Ember.ArrayController.extend
Buzz.CategoriesIndexController = Ember.ArrayController.extend
  all: ( -> this.store.find('category') ).property()

#Buzz.CategoriesShowController = Ember.ObjectController.extend
