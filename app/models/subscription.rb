class Subscription < ActiveRecord::Base
  belongs_to :podcast
  belongs_to :user

  validates :podcast, uniqueness: { scope: :user}

  default_scope { includes(:podcast).order('podcasts.title') }
end
