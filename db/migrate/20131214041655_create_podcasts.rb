class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :image_url
      t.string :feed_url

      t.timestamps
    end
  end
end
