class Api::V1::PodcastsController < Api::V1::AuthenticatedController
  respond_to :json
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]

  # GET /podcasts
  # GET /podcasts.json
  def index
    if params[:subscribed]
      user = params[:user] ? User.find_by_public_id_hash(params[:user]) : current_user
      @podcasts = user.podcasts.includes(:categories)
    elsif params[:popular]
      @podcasts = Podcast.popular
    elsif params[:ids]
      @podcasts = Podcast.where(id: params[:ids])
    elsif params[:search]
      @podcasts = Podcast.search(params[:q])
    else
      render json: { error: "Could not process #{params}" }, status: :unprocessable_entity
    end

    @limit = params[:limit]
    @offset = params[:offset]
    @total = @podcasts.count

    @podcasts = @podcasts.limit(params[:limit]).offset(params[:offset])
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
    @podcast
  end

  def create
    @podcast = Podcast.find_by podcast_params

    unless @podcast
      @podcast = Podcast.create_from_feed_url podcast_params[:feed_url]
    end

    if @podcast.valid?
      render 'show'
    else
      @podcast.errors.add(:feed_url, 'could not be parsed as RSS')
      render json: { errors: @podcast.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:feed_url)
    end
end
