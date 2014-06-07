class Podcast < ActiveRecord::Base
  #-- Associations
  has_many :episodes, inverse_of: :podcast, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_and_belongs_to_many :categories, unique: true

  accepts_nested_attributes_for :episodes, reject_if: proc { |ea| !Episode.new(ea).valid? }

  #-- Validations
  validates :feed_url, uniqueness: true, presence: true
  validates :title, presence: true

  #-- Scopes
  default_scope { order(:title) }
  scope :alphabetic, -> { order :title }
  scope :popular, -> { order('subscriptions_count desc') }

  scope :search, -> (query) do
    q = "lower(title) LIKE lower(:q) OR lower(feed_url) = lower(:q)"
    where(q, {q: "%#{query}%"})
  end

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

    image_urls = []

    # <image><url>___</url></image>
    if parsed_feed[:image_url].blank?
      image_urls << feed_giri.xpath('//channel/image/url').text
    end

    # <itunes:image>___</itunes:image>
    begin
      image_urls << feed_giri.xpath('//channel/itunes:image').text
    rescue Nokogiri::XML::XPath::SyntaxError => ex
      puts ex.message
    end

    #<itunes:image href"___" />
    begin
      image_giri = feed_giri.xpath('//channel/itunes:image').first
      image_urls << image_giri[:href] unless image_giri.nil?
    rescue Nokogiri::XML::XPath::SyntaxError => ex
      puts ex.message
    end

    # Some of the images in feeds are invalid.
    # Pick the first image that doesn't respond 4XX or 5XX.
    parsed_feed[:image_url] = image_urls.lazy.reject do |urlStr|
      if urlStr =~ /^#{URI::regexp}$/
        uri = URI.parse(urlStr)
        request = Net::HTTP.new uri.host
        response = request.request_head uri.path
        response.code =~ /[45][0-9]{2}/
      else
        true
      end
    end.first

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
    description = feed_giri.xpath('//channel/description').text
    # drop the first and last characters because they are always
    # extraneous single quotes
    description = sanitize(description)[1..-2]
    parsed_feed[:description] = description

    #-- Episodes
    parsed_feed[:episodes_attributes] = feed_giri.xpath('//channel/item').map do |node|
      Episode.parse_feed(node)
    end

    return parsed_feed
  end

end
