class PhotosController < ApplicationController
  respond_to :json, :html

  def top_users
    respond_with Photo.top_users(3)
  end

  def index
    respond_with Photo.order("photo_taken_at_time DESC")[0..24]
  end

  def photo_feed
    respond_with Photo.photo_feed(25)
  end

  def show
    respond_with Photo.find(params[:id])
  end

  def create
    respond_with Photo.create(params[:photo])
  end

  def update
    respond_with Photo.update(params[:id], params[:photo])
  end

  def destroy
    respond_with Photo.destroy(params[:id])
  end


end
