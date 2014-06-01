WebsocketRails::EventMap.describe do
  subscribe :client_connected, to: EventsController, with_method: :client_connected
  subscribe :client_disconnected, to: EventsController, with_method: :client_disconnected

  subscribe :claim_local_player, to: EventsController, with_method: :claim_local_player
  subscribe :release_local_player, to: EventsController, with_method: :release_local_player


  # Events sent by the local player to other clients
  namespace :event do
    %i{play pause volumechange progress timeupdate stalled durationchange}.each do |event|
      subscribe event, to: EventsController, with_method: :repeat_event
    end
  end

  # Events sent by other clients to the local player
  namespace :command do
    %i{play pause next mute unmute seek}.each do |event|
      subscribe event, to: EventsController, with_method: :repeat_command
    end
  end
end
