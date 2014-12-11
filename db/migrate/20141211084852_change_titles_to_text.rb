class ChangeTitlesToText < ActiveRecord::Migration
  def change
    change_column :episodes, :title, :text, limit: nil
    change_column :podcasts, :title, :text, limit: nil
  end
end
