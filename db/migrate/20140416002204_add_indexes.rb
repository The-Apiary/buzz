class AddIndexes < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.index :id_hash
    end

    change_table :episode_data do |t|
      t.index :episode_id
    end

    change_table :episodes do |t|
      t.index :publication_date
    end

    change_table :podcasts do |t|
      t.index :title
      t.index :subscriptions_count
    end

    change_table :categories do |t|
      t.index :name
    end

    change_table :categories_podcasts do |t|
      t.index :podcast_id
      t.index :category_id
    end

    change_table :queued_episodes do |t|
      t.index :episode_id
    end
  end
end
