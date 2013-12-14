class AddDescriptionToPodcast < ActiveRecord::Migration
  def change
    change_table :podcasts do |t|
      t.text :description
    end
  end
end
