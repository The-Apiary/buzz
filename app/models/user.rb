class User < ActiveRecord::Base
  #-- Associations
  has_many :subscriptions
  # has_many :episodes # Through subscriptions? Joined with episode_data?
  # has_many :episode_datas
  # has_many :queued_episodes # Should I change this to a list before continuing on with this?

  #-- Callbacks
  after_initialize :init

  #-- Validations
  validates :id_hash, presence: true, allow_blank?: false
  validates :id_hash, uniqueness: true

  def init
    return unless self.new_record?
    self.id_hash ||= User.new_hash # Let the default id_hash be overriden
  end

  # shorter way to create new subscriptions
  def subscribe podcast
    self.subscriptions.create(podcast: podcast)
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
