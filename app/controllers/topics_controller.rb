class TopicsController < ApplicationController

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new params[:topic]
    if @topic.save
      redirect_to topics_path, :notice => "Topic created"
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find_by(slug: params[:id]) || Topic.find_by(id: params[:id])
  end

  def update
    @topic = Topic.find params[:id]
    if @topic.update_attributes params[:topic].permit!
      redirect_to @topic, :notice => "Topic updated"
    else
      render :edit
    end
  end

  def show
    cookies[:'server-set'] = true
    redirect_to codemarks_path(:topic_ids => params[:id], :by => 'popularity')
  end

  def index
    respond_to do |format|
      format.json do
        @topics = Topic.for_user(current_user).select([:description, :slug, :title]).sort_by(&:title)
        render :json => PresentTopics.for(@topics)
      end

      format.html do
        @topics = Topic.for_user(current_user).order(:title)
        @topics = @topics.joins("LEFT JOIN (#{CodemarksTopic.select('topic_id, count(*)').group(:topic_id).to_sql}) cm_count ON topics.id = cm_count.topic_id").select('topics.*, COALESCE(cm_count.count, 0) as cm_count')
        @topics = @topics.to_a.shuffle
        @max = @topics.max_by { |t| t.cm_count.to_i }.cm_count.to_f
      end
    end
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
