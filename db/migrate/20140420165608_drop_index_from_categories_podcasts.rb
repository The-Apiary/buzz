class DropIndexFromCategoriesPodcasts < ActiveRecord::Migration
  def change
    drop_table :categories_podcasts
    create_table :categories_podcasts, id: false do |t|
      t.belongs_to :podcast
      t.belongs_to :category
      t.index :podcast_id, :category_id
      t.index :podcast_id
      t.index :category_id
    end
  end
end
