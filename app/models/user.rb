class User < ActiveRecord::Base
  #-- Associations
  has_many :subscriptions
  has_many :podcasts, through: :subscriptions
  has_many :episodes, through: :podcasts
  has_many :queued_episodes
  has_many :episode_datas

  #-- Callbacks
  after_initialize :init

  #-- Validations
  validates :id_hash, presence: true, allow_blank?: false
  validates :id_hash, uniqueness: true

  #-- Scopes
  scope :inactive_since, -> (time) { where(['last_login <= ?', time]) }
  scope :active_since, -> (time) { where(['last_login > ?', time]) }
  scope :anonymous, -> { where(provider: nil) }


  def init
    return unless self.new_record?
    self.id_hash ||= User.new_hash # Let the default id_hash be overriden
    self.public_id_hash ||= User.new_hash # Let the default id_hash be overriden
  end

  def identifier
    name || id_hash
  end

  def set_last_login
    self.last_login = Time.now
    self.save
  end

  def to_param
    self.id_hash
  end

  ##
  # List of episodes published in the last month
  def recently_published_episodes
    episodes
      .with_user_data(self)
      .newer_than(1.month.ago)
  end

  ##
  # List of episodes listened to in the last month,
  # orderd by last listened to.
  def recently_listened_episodes
    Episode
      .joins(:episode_datas)
      .order('episode_data.updated_at DESC')
      .where(['episode_data.updated_at > ?', 1.month.ago])
      .where(episode_data: { user_id: id })
  end

  def self.from_omniauth(auth, link_user=nil)
    link_user = nil unless link_user.is_a? User

    ##
    # Find or create the user account to associate with
    # this facebook account.
    #
    # 1. Look for existing facebook user.
    # 2. Use the +link_user+ if it exists.
    # 3. Create a new user.
    user = find_by(auth.slice(:provider, :uid)) ||
      link_user ||
      User.new

    user.image       = auth.info.image
    user.provider    = auth.provider
    user.uid         = auth.uid
    user.name        = auth.info.name
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!

    return user
  end

  # Removes inactive anonymous users
  def self.prune! time
      inactive_users = prunable_users time

      message = "Destroying #{inactive_users.count} inactive users"
      Rails.logger.info message
  end

  def self.prunable_users time
    User.anonymous.inactive_since(time)
  end


  private

  #-- Private class mehtods

  # Returns a random unclaimed id_hash
  def self.new_hash
    # Generate random ids until one that doesn't exist
    # is generated. Statistics say this shouldn't loop
    # untill there are a lot of users.
    begin
      id_hash = SecureRandom.urlsafe_base64
    end while User.exists?(id_hash: id_hash)

    return id_hash
  end

end
