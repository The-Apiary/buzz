# Adding another RSS feild to the podcast.
# Running the update feeds rake task should pull in the new info.
class AddLinkToPodcasts < ActiveRecord::Migration
  def change
    change_table :podcasts do |t|
      t.text :link_url
    end
  end
end
