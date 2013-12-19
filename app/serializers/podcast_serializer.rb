class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :feed_url
  has_many :episodes, embed: :ids
end
