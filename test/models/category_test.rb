require 'test_helper'

describe Category do

  describe 'default scope' do
    it 'orders by name' do
      # Create categories a through d in reverse order
      # This is just to ensure that there are some categories created,
      # and that some of them are created out of alphabetical order.
      ('a'..'d').to_a.reverse do |name|
        find_or_create(:podcast, name: name)
      end

      assert_equal Category.all, Category.all.order(:name), 'Order must be the same'
    end
  end

  describe '#name' do
    it 'cannot be blank' do
      assert_cannot_be_blank build(:category), :name
    end

    it 'must be unique' do
      existing_category = create(:category)
      new_category      = build(:category, name: existing_category.name)

      assert_invalid new_category, :name, 'has already been taken'
    end
  end

  describe '#podcasts' do
    it 'has many podcasts' do
      category = create(:category)
      assert_respond_to category, :podcasts
      assert_instance_of Podcast::ActiveRecord_Associations_CollectionProxy, category.podcasts
    end

    it 'there cannot be duplicate podcasts in the same category' do
      category = create(:category)

      msg = "A duplicate podcast should have been added, making the category invalid"

      # This checks that a duplicate podcast _can_ be added
      # the later assertion checks that doing so makes the category invalid.
      assert_difference 'category.podcasts.count', 1, msg do
        category.podcasts << category.podcasts.first
      end

      assert_invalid category, :podcasts, "cannot be repeated in the same category"
    end
  end

  describe '#to_param' do
    it 'should return the name of the podcast' do
      category = create(:category)
      assert_equal category.to_param, category.name
    end
  end
end
