##
# Manages a ordered list of episodes persisted in a SQL database
#
# Episodes can be added to any point, and reorded at any time.
#
# Episodes are given an index betweeen the minimum and maximim integer values
# defined in #min_idx and #max_idx
# These values were taken from the postgresql documentation
#
# When a new episode is added to the queue it's index is set to the midpoint
# of the surrounding episodes.
#
# If the episode is added beteen two episodes who's index are one apart
# the queue is rebased. All episodes are evenly dispersed throughout the 
# address space.
#
# NOTE: Rebaseing and some other operations should lock the table.
# + Does rails support locking tables?
# + Only lock queued_episodes owned by the user?
# + Add 'queue lock' field to user?
class QueueManager

  ##
  # A queue manager has a user.
  def initialize user
    unless user.is_a? User
      raise ArgumentError.new "Argument #{user} must be User but was #{user.class}"
    end

    @user = user
    @was_rebased = false
  end

  ##
  # Get the user's queued episodes
  def queued_episodes
    QueuedEpisode.where(user: @user)
  end

  ##
  # Did an operation cause the queue to be rebased?
  def rebased?
    @was_rebased
  end

  ##
  # Destroy all queued episodes
  def clear
    queued_episodes.destroy_all
  end

  ##
  # Add an episode to the end of the queue.
  def push(episode)
    do_with_rebase_retry do
      move_to_index episode, tail_index
    end
  end

  ##
  # Add an episode to the end of teh queue.
  def shift(episode)
    do_with_rebase_retry do
      move_to_index episode, head_index
    end
  end

  ##
  # Add an episode between two other episodes.
  def add_between(episode, after, before)
    do_with_rebase_retry do
      idxs = [episode_index(after), episode_index(before)]

      if idxs.any?(&:nil?)
        raise ArgumentError.new "before and after must be queued"
      end

      move_to_index(episode, index(*idxs))
    end
  end

  ##
  # Add an episode after another episode
  def add_after episode, after
    do_with_rebase_retry do
      after_idx = episode_index(after)
      other_idx = idx_after(after_idx)

      move_to_index episode, index(after_idx, other_idx)
    end
  end

  ##
  # Add an episode before another episode
  def add_before episode, before
    do_with_rebase_retry do
      before_idx = episode_index(before)
      other_idx = idx_before(before_idx)

      move_to_index episode, index(other_idx, before_idx)
    end
  end


  ##
  # Remove the episode from the queue.
  def remove(episode)
    queued_episodes.where(episode: episode).first.tap do |e|
      e.destroy
    end
  end

  ##
  # Minimum value of a Postgresql Integer
  def self.min_idx
    -2147483648
  end

  ##
  # Maximum value of a Postgresql Integer
  def self.max_idx
    2147483647
  end

  private

  ##
  # Evenly distributes the queued episodes throughout the address space
  def rebase
    @was_rebased = true
    qes = queued_episodes
    range = (QueueManager.min_idx..QueueManager.max_idx)

    # if the address space is 10 percent full don't rebase, just throw an
    # error.
    #
    # What would someone doing with 429496729 episodes in the queue?
    if qes.size > (range.size * 0.20)
      raise QueueTooLarge.new "Wut"
    end

    # Add one to the size to fenceposting
    step = (range.size / (qes.size + 1))

    if qes.size == 1
      # There are some rounding errors when size is one
      indexes = [0].each
    else
      indexes = ((QueueManager.min_idx+step)..(QueueManager.max_idx-step)).step(step).each
    end

    # NOTE: Can this be done in atomically?
    # Recaclulate indexes.
    qes.each do |qe|
      qe.idx = indexes.next
      qe.save
    end

    queued_episodes.reload

    return queued_episodes
  end

  ##
  # Set the index of the queued episode with episode e
  # to half way between f, and s
  def move_to_index e, idx
    raise ArgumentError "e must be an episode" unless e.is_a? Episode

    qe = queued_episodes.where(episode: e).first_or_initialize
    qe.update_attributes(idx: idx)

    return qe
  end

  ##
  # Get the index of an episode in the queue, or throw an error.
  def episode_index episode
    if episode.is_a? Episode
      queued_episodes.find_by_episode_id(episode).try(:idx)
    else
      raise ArgumentError "episodes must be owned by user"
    end
  end

  ##
  # Try to run the block, if GapTooSmall is raised
  # rebase and try again.
  #
  # Block should have no side effects before GapTooSmall might be raised.
  def do_with_rebase_retry(&block)
    begin
      yield block
    rescue GapTooSmall
      Rails.logger.tagged(:queue, :rebase) do
        Rails.logger.info "rebasing user #{@user.id}'s queue"

        rebase

        Rails.logger.info "done rebasing user #{@user.id}'s queue"

        yield block
      end
    end
  end

  ##
  # Get the index between the last episode and max value
  def tail_index
    index(queued_episodes.last.try(:idx) || QueueManager.min_idx, QueueManager.max_idx)
  end

  ##
  # Get the index between the first episode and min value
  def head_index
    index(QueueManager.min_idx, queued_episodes.first.try(:idx) || QueueManager.max_idx)
  end

  ##
  # The index of the episode after the passed episdoe
  def idx_after idx
    queued_episodes
      .where('idx > ?', idx)
      .order('idx asc')
      .first.try(:idx) || QueueManager.max_idx
  end

  ##
  # The index of the episode before the passed episdoe
  def idx_before idx
    queued_episodes
      .where('idx < ?', idx)
      .order('idx desc')
      .first.try(:idx) || QueueManager.min_idx
  end

  ##
  # Calculate the midpoint between two indexes
  # Throw an error if there isn't space between the two index's
  def index(low, high)
    unless low.is_a?(Fixnum) && high.is_a?(Fixnum)
      raise ArgumentError.new "Args must be Fuxnums"
    end

    idx = low + ((high - low) / 2)

    if idx == low || idx == high
      raise GapTooSmall.new "Could not insert record between #{low} and #{high}"
    else
      return idx
    end
  end
end

##
# Thrown when there is no space between episodes to add another episode
# should be cause, and the queue should be rebased.
class GapTooSmall < Exception
end

##
# Raised when the queue is too getting full.
# Full is defined arbitrarily at 10% of the address space (min int to max int)
class QueueTooLarge < Exception
end
