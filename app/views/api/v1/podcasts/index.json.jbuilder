json.array!(@podcasts) do |podcast|
  json.extract! podcast, :id, :title, :image_url, :feed_url
  json.url api_v1_podcast_url(podcast, format: :json)
end
