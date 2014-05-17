WebsocketRails::EventMap.describe do
  namespace :receive do
    %i{play pause volumechange progress}.each do |event|
      subscribe event, to: PlayerSocketController, with_method: event
    end
  end
end
