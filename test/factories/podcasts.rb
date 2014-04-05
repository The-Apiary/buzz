FactoryGirl.define do
  factory :podcast do
    title    "Podcast"
    feed_url { "http://podcast.com/#{SecureRandom.urlsafe_base64}" }
    image_url { "http://podcast.com/#{SecureRandom.urlsafe_base64}.img" }
    description "An invalid podcast"

    factory :radiolab do
      title    "Radiolab from WNYC"
      feed_url "http://feeds.wnyc.org/radiolab"
      image_url "http://www.wnyc.org/i/raw/1/Radiolab_1.png"
      description "Radiolab is a show about curiosity. Where sound ill..."
      link_url "http://www.radiolab.org/series/podcasts/"
    end
  end
end
