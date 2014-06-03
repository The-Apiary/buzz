
# This controller currently handles all socket events.
# I want to seperate this into multiple controller, but I don't know how
# to refactor `controller_store` calls to work with many controllers.
# I think I can use modules so that this will look a little better.
class EventsController < WebsocketRails::BaseController
  before_filter :setup

  def subscribe_private
    channel = WebsocketRails[message[:channel]].name.to_s

    if channel == @id_hash
      puts "#{client_id} subscribed to remote player channel"
      puts state
      accept_channel state
    elsif channel == client_id
      puts "#{client_id} subscribed to local player channel"
      accept_channel state
    else
      deny_channel message: 'authorization failed'
    end
  end

  ##
  # Repeats event events from the local player to the remote players.
  def repeat_event
    if is_local_player?
      update_state message

      message_others event.name, message, namespace: :event
      trigger_success message: "sent event #{event.name}"
    else
      trigger_failure message: "#{event.name} event must come from the local player"
    end
  end

  ##
  # Repeats commands from the remote players to the local player.
  # If there is no local player set client that sent this event as the local
  # player.
  def repeat_command
    if is_remote_player?
      claim_local_player if local_player.nil?

      message_local_player event.name, message, namespace: :command
      trigger_success message: "sent command #{event.name}"
    else
      trigger_failure message: "'#{event.name}' commands must come from remote players"
    end
  end

  def client_connected
    WebsocketRails[@id_hash].make_private
    WebsocketRails[client_id].make_private

    message = { client_id: client_id }
    message_others :connected, message
  end

  def client_disconnected
    release_local_player if is_local_player?

    message = { client_id: client_id }
    message_others :disconnected, message
  end

  def claim_local_player
    set_local_player client_id
  end

  ##
  # Sets local player to nil
  def release_local_player
    set_local_player nil if is_local_player?
  end

  private

  ##
  # Setup instance variables for this event.
  def setup

    @id_hash = request.cookies['id_hash']
    controller_store[@id_hash] ||= { local_player_id: nil, state: {} }
  end

  ##
  # Sets this client as the local player.
  def set_local_player(client)
    old_local_player = controller_store[@id_hash][:local_player_id]
    controller_store[@id_hash][:local_player_id] = client

    message_others :local_player_changed, {
      old_local_player: old_local_player,
      new_local_player: local_player,
    }
  end

  def state
    controller_store[@id_hash][:state]
  end

  def update_state(message)
    controller_store[@id_hash][:state].merge!(message)
  end

  def local_player
    controller_store[@id_hash][:local_player_id]
  end

  ##
  # Returns true if this client is the local player, returns false otherwise.
  def is_local_player?
    controller_store[@id_hash][:local_player_id] == client_id
  end

  ##
  # A plauer is remote if it isn't local.
  def is_remote_player?
    !is_local_player?
  end

  ##
  # Sends a messgae on the channel of the current local player's client_id
  # TODO: This channel should be authenticated, clients whos id is not the
  #       channel should be rejected.
  def message_local_player event, message, options={}
    unless local_player.nil?
      WebsocketRails[local_player].trigger event, message, options
    end
  end

  ##
  # Sends a message on the users channel.
  # TODO: This channel should be authenticated, clients whos session
  # is not the user should be rejected.
  def message_others event, message, options={}
    WebsocketRails[@id_hash].trigger event, message, options
  end
end
