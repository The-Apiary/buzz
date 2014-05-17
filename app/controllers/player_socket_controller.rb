class PlayerSocketController < WebsocketRails::BaseController
  before_filter -> { @id_hash = session[:id_hash] }
  %i{play pause volumechange progress}.each do |event|
    define_method(event) do
      repeat_event(event)
    end
  end

  # Sends messages sent by a user to each of the users connected clients.
  def repeat_event(event)
    puts event.to_s, message
    WebsocketRails[@id_hash].trigger event, message, namespace: :receive
  end
end
