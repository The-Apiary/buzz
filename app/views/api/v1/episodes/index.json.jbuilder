json.episodes @episodes do |episode|
  json.partial! 'episode', episode: episode
end

json.episode_datas @episode_datas do |episode_data|
  json.partial! 'api/v1/episode_datas/episode_data', episode_data: episode_data
end
