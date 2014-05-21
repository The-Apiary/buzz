
# This controller currently handles all socket events.
# I want to seperate this into multiple controller, but I don't know how
# to refactor `controller_store` calls to work with many controllers.
# I think I can use modules so that this will look a little better.
class EventsController < WebsocketRails::BaseController
  before_filter :setup

  ##
  # Repeats event events to the users channel.
  def repeat_event
    if is_master?
      puts "[Event] sending #{event.name.to_s}: #{message} to others"
      message_others event.name, message, :event
      trigger_success message: "sent #{event.name}"
    else
      trigger_failure message: "#{event.name} event must come from master"
    end
  end

  ##
  # Repeats command events to the master channel.
  def repeat_command
    puts "[Event] Sending #{event.name.to_s}: #{message} to master"
    message_master event.name, message, :command
  end

  def client_connected
    claim_master if master.nil? # TEMP - remove once master is automatically
                                # claimed when there is no active master.
    message = { message: "#{client_id} connected", master: master }
    broadcast_message :connected, message
  end

  def client_disconnected
    controller_store[@id_hash][:master_id] = nil if is_master?

    message = { message: "#{client_id} disconnected", master: master }
    broadcast_message :disconnected, message
  end

  private

  ##
  # Setup instance variables for this event.
  def setup
    @id_hash = request.cookies['id_hash']
    controller_store[@id_hash] ||= { master_id: nil }
  end

  def master
    controller_store[@id_hash][:master_id]
  end

  ##
  # Sets this client as the master.
  def claim_master
    controller_store[@id_hash][:master_id] = client_id
  end

  ##
  # Sets master to nil
  def release_master
    controller_store[@id_hash][:master_id] = nil
  end

  ##
  # Returns true if this client is the master, returns false otherwise.
  def is_master?
    controller_store[@id_hash][:master_id] == client_id
  end

  ##
  # Sends a messgae on the channel of the current master's client_id
  # TODO: This channel should be authenticated, clients whos id is not the
  #       channel should be rejected.
  def message_master event, message, namespace
    unless master.nil?
      WebsocketRails[master].trigger event, message, namespace: namespace
    end
  end

  ##
  # Sends a message on the users channel.
  # TODO: This channel should be authenticated, clients whos session
  # is not the user should be rejected.
  def message_others event, message, namespace
    puts "trigger #{namespace}.#{event} on #{@id_hash}"
    WebsocketRails[@id_hash].trigger event, message, namespace: namespace
  end
end
