class Podcast < ActiveRecord::Base
  #-- Associations
  has_many :episodes, inverse_of: :podcast, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_and_belongs_to_many :categories

  accepts_nested_attributes_for :episodes, reject_if: proc { |ea| !Episode.new(ea).valid? }

  #-- Validations
  validates :feed_url, uniqueness: true, presence: true
  validates :title, presence: true

  #-- Scopes
  default_scope { order(:title).includes(:categories) }
  scope :alphabetic, -> { order :title }
  scope :popular, -> { order('subscriptions_count desc') }

  def add_category name
    new_cat = Category.where(name: name).first_or_create
    categories << new_cat unless categories.include? new_cat

    return categories
  end

  def category_names
    categories.map(&:name)
  end

  #-- Public class mehtods

  # Create a new podcast from the passed url
  # Returns the new podcast
  def self.create_from_feed_url feed_url
    podcast_data = Podcast.parse_feed feed_url
    podcast_data[:categories] =
      podcast_data[:categories].uniq.map { |name| Category.find_or_initialize_by name: name }

    podcast = Podcast.create podcast_data

    return podcast
  end

  # Parse podcast and episode info from the feed.
  # Returns a hash object.
  def self.parse_feed feed_url, ttl=1.hour
    parsed_feed = Hash.new
    feed_xml = FeedCache.open feed_url, ttl
    feed_giri = Nokogiri::XML(feed_xml)

    #-- Feed_url
    parsed_feed[:feed_url] = feed_url

    #-- Link_url
    parsed_feed[:link_url] = feed_giri.xpath('//channel/link').text

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
      logger.tagged('Update Feeds', parsed_feed[:title]) { logger.debug "Failed to get image." }
    end

    #-- Categories

    categories = Array.new

    ## <media:category>___</media:category>
    begin
      categories += feed_giri.xpath('//channel/media:category').map(&:text).to_a
    rescue Nokogiri::XML::XPath::SyntaxError
      logger.tagged('Update Feeds', parsed_feed[:title]) { logger.debug "Failed to get media:category." }
    end

    ## <itunes:category text="___">
    begin
      categories += feed_giri.xpath('//channel/itunes:category').map { |node| node[:text] }
    rescue Nokogiri::XML::XPath::SyntaxError
      logger.tagged('Update Feeds', parsed_feed[:title]) { logger.debug "Failed to get itunes:category." }
    end

    # Split strings with &'s or /'s into multiple categories
    categories = categories.map { |c| c.split(/[\/&]/) }.flatten

    parsed_feed[:categories] = categories.map(&:strip).uniq.reject(&:blank?)

    #-- Description
    parsed_feed[:description] = feed_giri.xpath('//channel/description').text

    #-- Episodes
    parsed_feed[:episodes_attributes] = feed_giri.xpath('//channel/item').map do |node|
      Episode.parse_feed(node)
    end

    return parsed_feed
  end
end
