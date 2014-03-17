class Subscription < ActiveRecord::Base
  #-- Associations
  belongs_to :podcast
  belongs_to :user

  #-- callbacks
  before_validation :downcase_subscription_type

  #-- Validattions
  validates :podcast, uniqueness: { scope: :user}

  # Valid podcast subscriptions types
  valid_types = ['normal', 'serial', 'news']
  validates :subscription_type, inclusion: {in: valid_types, message: "'%{value}' is not in #{valid_types.inspect}"}

  #-- Scopes
  default_scope { includes(:podcast).order('podcasts.title') }

  private

  def downcase_subscription_type
    self.subscription_type.downcase!
  end
end
