class AddLastLoginToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.datetime :last_login, default: Time.now
    end
  end
end
