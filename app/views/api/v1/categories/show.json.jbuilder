json.category do |json|
  json.partial! 'category', category: @category
end

json.podcasts @category.podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end
