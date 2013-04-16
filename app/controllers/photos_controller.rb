class PhotosController < ApplicationController
  respond_to :json, :html

  def index
    respond_with Photo.all.shuffle
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
