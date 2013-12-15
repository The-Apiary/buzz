require 'open-uri'
class Podcast < ActiveRecord::Base
  #-- Associations
  has_many :episodes, dependent: :destroy

  #-- Callbacks
  before_validation :get_metadata_from_feed!
  after_create :get_episodes_from_feed!

  #-- Validations
  validates :feed_url, uniqueness: true, presence: true
  validates :title, presence: true

  #-- Scopes
  default_scope order :title

  #-- Public instance methods

  # Creates new episodes, changes the title, image, and other podcast attributes
  def get_metadata_from_feed!
    feed = parse_feed
    # Update metadata
    self.title = feed[:title]
    self.image_url = feed[:image_url]
    self.description = feed[:description]
  end

  def get_episodes_from_feed!
    feed = parse_feed
    feed[:episodes].each do |episode|
      episode = Episode.parse_feed(episode)
      self.episodes.create(episode)
    end
    puts "episodes: #{self.episodes.count}"
  end

  private

  #-- Private instance methods

  # parses the feed xml into a hash containing podcast metadata, and episode info
  def parse_feed args={}
    args = { skip_cache: false }.merge args # default arguments

    if @cached_feed.nil? || args[:skip_cache]
      puts "Downloading feed"
      @cached_feed = Hash.new
      feed_xml = open feed_url
      feed_giri = Nokogiri::XML(feed_xml)
      #-- Title
      @cached_feed[:title] = feed_giri.xpath('//channel/title').text

      #-- Image_url

      # <image><url>...</url></image>
      @cached_feed[:image_url] = feed_giri.xpath('//channel/image/url').text

      # <itunes:image>...</itunes:image>
      if @cached_feed[:image_url].blank?
        @cached_feed[:image_url] = feed_giri.xpath('//channel/itunes:image').text
      end

      #<itunes:image href"..." />
      if @cached_feed[:image_url].blank?
        image_giri = feed_giri.xpath('//channel/itunes:image').first
        @cached_feed[:image_url] = image_giri[:href] unless image_giri.nil?
      end

      #-- Description
      @cached_feed[:description] = feed_giri.xpath('//channel/description').text

      #-- Episodes
      @cached_feed[:episodes] = feed_giri.xpath('//channel/item')
    end


    return @cached_feed
  end
end
