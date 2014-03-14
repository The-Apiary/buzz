class Episode < ActiveRecord::Base
  # Used durring creation to verify that the episode is an audio podcast.
  attr_accessor :podcast_type

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
  validates :podcast_type, inclusion: {in: [:audio], message: "'%{value}' is not 'audio'"}, on: :create
  validates :podcast_type, presence: true, allow_blank?: false, on: :create

  #-- Scopes
  default_scope { order(publication_date: :desc) }

  def self.parse_feed(node)
    episode_hash = Hash.new

    episode_hash[:title] = node.xpath('title').text
    episode_hash[:link_url] = node.xpath('link').text
    episode_hash[:description] = node.xpath('description').text
    episode_hash[:guid] = node.xpath('guid').text

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
      episode_hash[:podcast_type] = :audio
      episode_hash[:audio_url] = enclosure[:url]
    else
      episode_hash[:podcast_type] = :other
    end

    return episode_hash
  end

  def episode_data(user)
    episode_datas.detect { |ed| ed.user == user }
  end
end
