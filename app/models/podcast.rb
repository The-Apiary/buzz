require 'open-uri'
class Podcast < ActiveRecord::Base
  #-- Callbacks
  before_validation :update_from_feed!

  #-- Validations
  validates :feed_url, uniqueness: true, presence: true
  validates :title, presence: true

  #-- Public instance methods

  # Creates new episodes, changes the title, image, and other podcast attributes
  def update_from_feed!
    feed = parse_feed
    # Update metadata
    self.title = feed[:title]
    self.image_url = feed[:image_url]
    self.description = feed[:description]

    puts "title: #{self.title}"
    puts "feed_url: #{self.feed_url}"
    puts "image_url: #{self.image_url}"
    puts "description: #{self.description}"

    puts "episodes: #{feed[:episodes].count}"
  end

  private

  #-- Private instance methods
  
  # parses the feed xml into a hash containing podcast metadata, and episode info
  def parse_feed
    feed = Hash.new
    feed_xml = open feed_url
    feed_giri = Nokogiri::XML(feed_xml)
    # Title
    feed[:title] = feed_giri.xpath('//channel/title').text

    # Image_url
    feed[:image_url] = feed_giri.xpath('//channel/image/url').text

    # Description
    feed[:description] = feed_giri.xpath('//channel/description').text

    # Episodes
    feed[:episodes] = feed_giri.xpath('//channel/item')


    return feed
  end
end
