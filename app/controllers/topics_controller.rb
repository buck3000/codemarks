class TopicsController < ApplicationController

  def new
    @topic = Topic.new
    build_missing_sponsored_sites
  end

  def create
    @topic = Topic.new params[:topic]
    if @topic.save
      redirect_to topics_path, :notice => "Topic created"
    else
      build_missing_sponsored_sites
      render :new
    end
  end

  def edit
    @topic = Topic.find params[:id]
    build_missing_sponsored_sites
  end

  def update
    @topic = Topic.find params[:id]
    if @topic.update_attributes params[:topic]
      redirect_to topics_path, :notice => "Topic updated"
    else
      build_missing_sponsored_sites
      render :edit
    end
  end

  def show
    @topic = Topic.find params[:id]
    @resources = []

    if params[:sort] == "save_count"
      @resources = @topic.links.by_save_count
    elsif params[:sort] == "clicks"
      @resources = @topic.links.by_click_count
    else
      @resources = @topic.links
    end
  end

  def index
    @topics = Topic.scoped
    
    if filter_by_mine?
      @topics = @topics.mine current_user_id
    end

    sort_order = params[:sort]
    if sort_order == 'resource_count'
      @topics = @topics.by_resource_count
    elsif sort_order == 'recent_activity'
      @topics = @topics.by_recent_activity
    end

    @topics = @topics.page params[:pg]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @topic = Topic.find params[:id]
  end

  private

  def build_missing_sponsored_sites
    missing_sponsored_sites = SponsoredSite::SponsoredSites.constant_values - @topic.sponsored_sites.collect(&:site)
    missing_sponsored_sites.each do |site|
      @topic.sponsored_sites.build(:site => site)
    end
  end
end
