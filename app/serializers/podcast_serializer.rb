class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :feed_url, :episode_count
  has_many :episodes, embed: :ids
end
