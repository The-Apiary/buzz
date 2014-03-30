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
  end

  def identifier
    name || id_hash
  end

  def login
    self.last_login = Time.now
    self.save
  end

  def to_param
    self.id_hash
  end

  def self.from_omniauth(auth, link_user)
    link_user = nil unless link_user.is_a? User

    # Find existing omniauth user.
    user = find_by(auth.slice(:provider, :uid)) ||
      link_user ||
      User.new

    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
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
