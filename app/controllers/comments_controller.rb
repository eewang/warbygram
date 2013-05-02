class CommentsController < ApplicationController
  respond_to :json, :html

  def index
    respond_with Comment.all.shuffle
  end

  def show
    respond_with Comment.find(params[:id])
  end

  def create
    respond_with Comment.create(params[:photo])
  end

  def update
    respond_with Comment.update(params[:id], params[:photo])
  end

  def destroy
    respond_with Comment.destroy(params[:id])
  end

end
