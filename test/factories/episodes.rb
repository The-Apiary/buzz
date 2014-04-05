FactoryGirl.define do
  factory :episode do
    title    "Episode"
    audio_url { "http://podcast.com/#{SecureRandom.urlsafe_base64}.mp3" }
    description "episode description"
    podcast_type :audio
    publication_date { Time.now }
    podcast
  end
end

