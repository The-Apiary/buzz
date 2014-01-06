json.episode_datas @episode_datas do |episode_data|
  json.partial! 'episode_data', episode_data: episode_data
end

