#Buzz.EpisodeController = Ember.ArrayController.extend
Buzz.CategoriesIndexController = Ember.ArrayController.extend
  all: ( -> Buzz.Category.find() ).property()

#Buzz.CategoriesShowController = Ember.ObjectController.extend
