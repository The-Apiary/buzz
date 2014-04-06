class QueueManager
  def initialize user
    unless user.is_a? User
      raise ArgumentError.new "Argument #{user} must be User but was #{user.class}"
    end

    @user = user
    @was_rebased = false
  end

  def rebased?
    @was_rebased
  end

  def clear
    @user.queued_episodes.destroy_all
  end

  def push(episode)
    begin
      move_to_index episode, tail_index
    rescue GapTooSmall
      rebase
      push episode
    end
  end

  def shift(episode)
    begin
      move_to_index episode, head_index
    rescue GapTooSmall
      rebase
      shift episode
    end
  end

  def add_between(episode, after: after, before: before)
    begin
      idxs = [episode_index(after), episode_index(before)]

      if idxs.any?(&:nil?)
        raise ArgumentError.new "before and after must be queued"
      end

      move_to_index(episode, index(*idxs))
    rescue GapTooSmall
      rebase
      add_between(episode, after: after, before: before)
    end
  end

  def remove(episode)
    @user.queued_episodes.where(episode: episode).first.tap do |e|
      e.destroy
    end
  end

  # Min value of a Postgresql Integer
  def self.min_idx
    -2147483648
  end

  # Max value of a Postgresql Integer
  def self.max_idx
    2147483647
  end

  private

  ##
  # Evenly distributes the queued episodes throughout the address space
  def rebase
    Rails.logger.tagged(:queue, :rebase) { Rails.logger.info "rebasing user #{@user.id}'s queue" }
    @was_rebased = true
    qes = @user.queued_episodes
    range = (QueueManager.min_idx..QueueManager.max_idx)

    # if the address space is 10 percent full don't rebase, just throw an
    # error.
    #
    # What is someone doing with 429496729 episodes in the queue?
    if qes.size > (range.size * 0.20)
      raise QueueTooLarge.new "Wut"
    end

    # Add two to the size for beginning and end padding
    # and add another for fence posts
    step = (range.size / (qes.size + 1))

    if qes.size == 1
      # there are some rounding errors when size is one
      indexes = [0].each
    else
      indexes = ((QueueManager.min_idx+step)..(QueueManager.max_idx-step)).step(step).each
    end

    qes.each do |qe|
      qe.idx = indexes.next
      qe.save
    end

    @user.queued_episodes.reload

    Rails.logger.tagged(:queue, :rebase) { Rails.logger.info "done rebasing user #{@user.id}'s queue" }

  end

  def episode_index episode
    if episode.is_a? Episode
      @user.queued_episodes.find_by_episode_id(episode).try(:idx)
    else
      raise ArgumentError "episodes must be owned by user"
    end

  end

  ##
  # Set the index of the queued episode with episode e
  # to half way between f, and s
  def move_to_index e, idx
    raise ArgumentError "e must be an episode" unless e.is_a? Episode

    qe = @user.queued_episodes.where(episode: e).first_or_initialize
    qe.update_attributes(idx: idx)

    return qe
  end

  def tail_index
    index(@user.queued_episodes.last.try(:idx) || QueueManager.min_idx, QueueManager.max_idx)
  end

  def head_index
    index(QueueManager.min_idx, @user.queued_episodes.first.try(:idx) || QueueManager.max_idx)
  end

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

class GapTooSmall < Exception
end

class QueueTooLarge < Exception
end
