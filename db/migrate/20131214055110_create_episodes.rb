class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :audio_url
      t.string :link_url
      t.string :guid
      t.text :description

      t.datetime :publication_date

      t.references :podcast, index: true

      t.timestamps
    end
  end
end
