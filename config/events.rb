WebsocketRails::EventMap.describe do
  subscribe :client_connected, to: PlayerSocketController, with_method: :client_connected
  subscribe :client_disconnected, to: PlayerSocketController, with_method: :client_disconnected

  namespace :audio do
    %i{play pause volumechange progress timeupdate stalled durationchange}.each do |event|
      subscribe event, to: PlayerSocketController, with_method: event
    end
  end
end
