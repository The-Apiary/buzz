include ActionView::Helpers::SanitizeHelper
class Episode < ActiveRecord::Base
  #-- Associations
  belongs_to :podcast, inverse_of: :episodes
  has_one :queued_episode, dependent: :destroy
  has_many :episode_datas

  #-- Validations

  #NOTE: this is disabled so episodes can validated without podcasts.
  #validates_presence_of :podcast
  validates :title, :audio_url, :publication_date, presence: true, allow_blank?: false
  validates :audio_url, uniqueness: true
  validates :guid, uniqueness: true, unless: 'guid.blank?'
  validates :episode_type,
    format: { with: /audio/, message: "'%{value}' is not audio"  },
    on: :create,
    unless: 'episode_type.blank?'

  validates :episode_type, presence: true, allow_blank?: false, on: :create

  #-- Scopes
  default_scope { freshest }

  scope :search, -> (query) { where("lower(title) LIKE lower(?)", "%#{query}%") }
  scope :freshest, -> { order(publication_date: :desc) }
  scope :newer_than, -> (date) { where(['publication_date > ?', date]) }

  def self.parse_feed(node)
    episode_hash = Hash.new

    #:: Title
    episode_hash[:title] = CGI.unescapeHTML node.xpath('title').text

    #:: Link url
    episode_hash[:link_url] = node.xpath('link').text

    #:: Description
    description = node.xpath('description').text
    if description.blank?
      begin
        description = node.xpath('itunes:summary').text
      rescue Nokogiri::XML::XPath::SyntaxError => ex
        puts ex.message
      end
    end
    # drop the first and last characters because they are always
    # extraneous single quotes
    description = sanitize(description)[1..-2]
    episode_hash[:description] = description

    #:: GUID
    episode_hash[:guid] = node.xpath('guid').text

    #:: Publication date
    episode_hash[:publication_date] = node.xpath('pubDate').text

    # duration is a string, usually [hh]:mm:ss
    duration = begin
      node.xpath('itunes:duration').text
    rescue
      nil
    end

    unless duration.blank?
      begin
        episode_hash[:duration] = Duration.new(duration).in_seconds
      rescue DurationParseError => ex
        logger.error ex.message
      end
    end

    enclosure = node.xpath('enclosure').first
    # This application only supports audio podcasts
    if enclosure && enclosure[:type].match(/audio/)
      episode_hash[:episode_type] = enclosure[:type]
      episode_hash[:audio_url] = enclosure[:url]
    end

    return episode_hash
  end


  def episode_data(user)
    episode_datas.find_by user: user
  end

  def current_position(user)
    episode_data(user).try(:current_position) || 0
  end

  def is_played(user)
    episode_data(user).try(:is_played) || false
  end

  def last_listened_at(user)
    episode_data(user).try(:updated_at) || nil
  end
end
