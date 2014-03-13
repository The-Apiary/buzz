require 'open-uri'
class Podcast < ActiveRecord::Base
  #-- Associations
  has_many :episodes, inverse_of: :podcast, dependent: :destroy

  accepts_nested_attributes_for :episodes

  #-- Validations
  validates :feed_url, uniqueness: true, presence: true
  validates :title, presence: true

  #-- Scopes
  default_scope { order :title }
  scope :alphabetic, -> { order :title }

  #-- Public class mehtods

  # Create a new podcast from the passed url
  # Returns the new podcast
  def self.create_from_feed_url feed_url
    podcast_data = Podcast.parse_feed feed_url
    episodes_data = podcast_data[:episodes_attributes]

    podcast_data[:episodes_attributes] = []
    podcast = Podcast.create podcast_data

    episodes_data.each { |ed| podcast.episodes.create ed }

    return podcast
  end

  # Parse podcast and episode info from the feed.
  # Returns a hash object.
  def self.parse_feed feed_url
    parsed_feed = Hash.new
    feed_xml = open feed_url
    feed_giri = Nokogiri::XML(feed_xml)

    #-- Feed_url
    parsed_feed[:feed_url] = feed_url

    #-- Title
    parsed_feed[:title] = feed_giri.xpath('//channel/title').text

    #-- Image_url
    # I've seen three image url formats: an image tag, itunes:image tag,
    # and itunes:image tag with the url as its href attribute.

    # <image><url>...</url></image>
    parsed_feed[:image_url] = feed_giri.xpath('//channel/image/url').text

    begin
      # <itunes:image>___</itunes:image>
      if parsed_feed[:image_url].blank?
          parsed_feed[:image_url] = feed_giri.xpath('//channel/itunes:image').text
      end

      #<itunes:image href"___" />
      if parsed_feed[:image_url].blank?
        image_giri = feed_giri.xpath('//channel/itunes:image').first
        parsed_feed[:image_url] = image_giri[:href] unless image_giri.nil?
      end
    rescue
      logger.tagged('Update Feeds', self.title) { logger.warn "Failed to get image." }
    end

    #-- Description
    parsed_feed[:description] = feed_giri.xpath('//channel/description').text

    #-- Episodes
    parsed_feed[:episodes_attributes] = feed_giri.xpath('//channel/item').map do |node|
      Episode.parse_feed(node)
    end

    return parsed_feed
  end
end
