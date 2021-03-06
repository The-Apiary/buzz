include ActionView::Helpers::SanitizeHelper
class Episode < ActiveRecord::Base
  #-- Associations
  belongs_to :podcast, inverse_of: :episodes
  has_many :queued_episodes, dependent: :destroy
  has_many :episode_datas, dependent: :destroy

  #-- Validations

  #NOTE: this is disabled so episodes can validated without podcasts.
  #validates_presence_of :podcast

  validates_presence_of :title,
                        :audio_url,
                        :publication_date,
                        :episode_type,
                        allow_blank?: false

  validates_uniqueness_of :audio_url
  validates_uniqueness_of :guid, unless: 'guid.blank?'

  # Validates that episode_type matches 'audio'
  validates :episode_type,
    format: { with: /audio/, message: "'%{value}' does not contain 'audio'" }


  #-- Scopes
  default_scope { freshest }

  scope :search, -> (query) { where("lower(title) LIKE lower(?)", "%#{query}%") }
  scope :freshest, -> { order(publication_date: :desc) }
  scope :oldest, -> { order(publication_date: :asc) }
  scope :newer_than, -> (date) { where(['publication_date > ?', date]) }


  # This weird scope is used to order rows after grouping
  # (usually after distinct_podcasts)
  scope :order_groups, ->(order_args) do
    sql = current_scope.to_sql
    self.unscoped
      .from("(#{sql}) episodes")
      .order(order_args)
  end

  # Returns all episodes from podcasts the user is subscribed to.
  # If a type is passed only podcasts of that subscription type will be
  # included.
  scope :subscribed, -> (user, type: nil) do
    subs = Subscription.unscoped.where(user_id: user.id)
    subs = subs.where(subscription_type: type) unless type.nil?

    where(podcast: subs.select(:podcast_id))
  end

  scope :with_user_data, -> (user) do
      joins("""LEFT OUTER JOIN episode_data
               ON episodes.id = episode_data.episode_id
               and (
                 episode_data.user_id = #{user.id}
                 OR
                 episode_data.user_id IS NULL
               )
            """)
        .select("""
          episodes.*,
          episode_data.is_played AS ed_is_played,
          episode_data.current_position AS ed_current_position,
          episode_data.user_id AS ed_user_id,
          episode_data.updated_at AS ed_last_played,
          episode_data.id AS ed_id
        """)
  end

  # Returns all episodes not heard by the passed user.
  scope :unplayed, -> (user) do
      with_user_data(user)
      .where("episode_data.is_played IS NOT true")
  end

  scope :distinct_podcasts, -> do
      select("DISTINCT ON (episodes.podcast_id) episodes.*")
      .order("episodes.podcast_id") # DISTINCT ON Must be ordered
  end

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
    unless user.is_a? User
      raise ArgumentError.new "Argument user must be a User not #{user.class}"
    end

    episode_datas.find_by user: user
  end


  def current_position(user)
    attr_or_query("current_position", user) || 0
  end

  def is_played(user)
    attr_or_query("is_played", user) || false
  end

  def last_listened_at(user)
    attr_or_query("last_played", user) || nil
  end

  private

  def attr_or_query(attr, user)
    unless user.is_a? User
      raise ArgumentError.new "Argument user must be a User not #{user.class}"
    end

    ed_attr = "ed_#{attr}"

    if has_attribute?(ed_attr)
      attributes[ed_attr]
    else
      episode_data(user).try(attr)
    end
  end
end
