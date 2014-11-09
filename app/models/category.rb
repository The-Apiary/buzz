##
# A category collects a set of podcasts.
# Podcasts are added to a category if any one of a number of fields in their
# XML feed includes the name of the category.
# See Podcast#parse_feed
class Category < ActiveRecord::Base
  #:: Relations
  has_and_belongs_to_many :podcasts

  #:: Validations
  validates :name, uniqueness: true, presence: true

  validate :uniqueness_of_podcasts_in_category

  #:: Scopes
  default_scope { order :name }

  #:: Methods

  ##
  # Use the catagory name as the identifying parameter for this model.
  # e.g. /api/v1/categories/:name
  def to_param
    name
  end

  private

  ##
  # Checks that there are no repeated podcasts in the category.
  def uniqueness_of_podcasts_in_category
    unless podcasts.to_a.uniq.count == podcasts.to_a.count
      errors.add(:podcasts, "cannot be repeated in the same category")
      return false
    end
  end
end
