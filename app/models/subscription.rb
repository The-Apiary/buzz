class Subscription < ActiveRecord::Base
  #-- Associations
  belongs_to :podcast
  belongs_to :user

  #-- callbacks
  before_validation :titlecase_subscription_type

  #-- Validattions
  validates :podcast, uniqueness: { scope: :user}

  # Valid podcast subscriptions types
  valid_types = ['Normal', 'Serial', 'News']
  validates :subscription_type, inclusion: {in: valid_types, message: "'%{value}' is not in #{valid_types.inspect}"}

  #-- Scopes
  default_scope { includes(:podcast).order('podcasts.title') }

  private

  def titlecase_subscription_type
    # Why does `downcase!` exist, but not `titlecase!` ?!
    self.subscription_type = self.subscription_type.try(:titlecase) || 'Normal'
  end
end
