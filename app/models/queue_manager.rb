class QueueManager
  def initialize user
    unless user.is_a? User
      raise ArgumentError.new "Argument #{user} must be User but was #{user.class}"
    end

    @user = user
  end

  def clear
    @user.queued_episodes.destroy_all
  end

  def enqueue(episode)
    @user.queued_episodes.where(episode: episode).first_or_create(idx: tail_index)
  end

  def head_enqueue(episode)
    @user.queued_episodes.where(episode: episode).first_or_create(idx: head_index)
  end

  def dequeue(episode)
    @user.queued_episodes.where(episode: episode).first.tap do |e|
      e.destroy
    end
  end


  # Min value of a Postgresql Integer
  def min_idx
    -2147483648
  end

  # Max value of a Postgresql Integer
  def max_idx
    2147483647
  end
   
  private

  def tail_index
    index(@user.queued_episodes.last.try(:idx) || min_idx, max_idx)
  end

  def head_index
    index(min_idx, @user.queued_episodes.first.try(:idx) || max_idx)
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
