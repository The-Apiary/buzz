WebsocketRails::EventMap.describe do
  subscribe :client_connected, to: EventsController, with_method: :client_connected
  subscribe :client_disconnected, to: EventsController, with_method: :client_disconnected

  # Events sent by the master to other clients
  namespace :event do
    %i{play pause volumechange progress timeupdate stalled durationchange}.each do |event|
      subscribe event, to: EventsController, with_method: :repeat_event
    end
  end

  # Events sent by other clients to the master
  namespace :command do
    %i{play pause next}.each do |event|
      subscribe event, to: EventsController, with_method: :repeat_command
    end
  end
end
