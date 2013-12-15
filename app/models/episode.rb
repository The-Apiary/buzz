class Episode < ActiveRecord::Base
  #-- Associations
  belongs_to :podcast

  #-- Validations
  validates :podcast, :title, :audio_url, :guid, :publication_date, presence: true
  validates :guid, uniqueness: true

  #-- Scopes
  default_scope order(publication_date: :desc)

  def self.parse_feed(node)
    episode = Hash.new

    episode[:title] = node.xpath('title').text
    episode[:link_url] = node.xpath('link').text
    episode[:description] = node.xpath('description').text
    episode[:guid] = node.xpath('guid').text

    episode[:publication_date] = node.xpath('pubDate').text

    enclosure = node.xpath('enclosure').first
    if enclosure && enclosure[:type].match(/audio/)
      episode[:audio_url] = enclosure[:url]
    end

    return episode
  end
end
