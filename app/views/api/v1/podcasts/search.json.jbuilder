json.array! @podcasts do |podcast|
  json.id podcast.id
  json.title podcast.title
  json.image_url podcast.image_url
end
