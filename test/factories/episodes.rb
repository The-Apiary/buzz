FactoryGirl.define do

  factory :episode do
    sequence(:title)     { |n| "Episode #{n}" }
    sequence(:audio_url) { |n| "http://podcast.com/episode/#{n}.mp3" }
    description "episode description"
    podcast_type :audio
    publication_date { Time.now }
    podcast
  end
end

