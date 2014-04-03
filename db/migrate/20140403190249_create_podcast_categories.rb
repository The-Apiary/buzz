class CreatePodcastCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name
    end

    create_table :categories_podcasts do |t|
      t.belongs_to :podcast
      t.belongs_to :category
    end
  end
end
