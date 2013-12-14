json.array!(@podcasts) do |podcast|
  json.extract! podcast, :id, :title, :image_url, :feed_url
  json.url podcast_url(podcast, format: :json)
end
