class AddPublicIdHashToUser < ActiveRecord::Migration
  def change
    add_column :users, :public_id_hash, :string

    User.find_each do |user|
      user.public_id_hash ||= User.new_hash
      user.save
    end
  end
end
