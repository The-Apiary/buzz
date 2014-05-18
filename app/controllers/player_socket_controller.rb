class PlayerSocketController < WebsocketRails::BaseController
  before_filter :setup_user

  def client_connected
    message = { message: "#{client_id} connected", master: controller_store[:id_hash] }
    puts message
    broadcast_message :connected, message
  end

  def client_disconnected
    controller_store[@id_hash][:master_id] = client_id if is_master?

    message = { message: "#{client_id} disconnected", master: controller_store[:id_hash] }
    puts message
    broadcast_message :disconnected, message
  end

  # These events should always come frome the master
  %i{play pause volumechange progress timeupdate stalled durationchange}.each do |event|
    # Sends messages sent by a user to each of the users connected clients.
    define_method(event) do
      if is_master?
        puts "Repeating #{event.to_s}: #{message} to others"
        message_others event, message, namespace: :audio
        trigger_success message: "sent #{event}"
      else
        trigger_failure message: "#{event} event must come from master"
      end
    end
  end

  private

  def setup_user
    @id_hash = session[:id_hash]
    controller_store[@id_hash] ||= { master_id: nil }
    @master = controller_store[@id_hash][:master_id]
  end

  def claim_master
    controller_store[@id_hash][:master_id] = client_id
  end

  def is_master?
    controller_store[@id_hash][:master_id] == client_id
  end

  def message_master event, message, *options
    unless @master.nil?
      WebsocketRails[@master].trigger event, message, options
    end
  end

  def message_others event, message, *options
    WebsocketRails[@id_hash].trigger event, message, options
  end
end
