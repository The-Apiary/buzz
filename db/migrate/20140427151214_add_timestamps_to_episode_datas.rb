class AddTimestampsToEpisodeDatas < ActiveRecord::Migration
  def change
    change_table :episode_data do |t|
      t.timestamps
    end

    # Set the updated and created times for existing episode datas.
    # The listening order of these existing episodes can be unreliably
    # related to the episode's ids.
    User.find_each do |user|
      user.episode_datas.order('id DESC').each_with_index do |ed, i|
        time = i.seconds.ago
        ed.update created_at: time, updated_at: time
      end
    end
  end
end
