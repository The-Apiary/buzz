class PlayerSocketController < WebsocketRails::BaseController
  before_filter -> { @id_hash = session[:id_hash] }
  %i{play pause volumechange progress}.each do |event|
    # Sends messages sent by a user to each of the users connected clients.
    define_method(event) do
      puts "Repeating #{event.to_s}: #{message}"
      WebsocketRails[@id_hash].trigger event, message, namespace: :audio
    end
  end
end
