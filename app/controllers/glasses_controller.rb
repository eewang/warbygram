class GlassesController < ApplicationController
  respond_to :json, :html

  def index
    @glasses_captions = Glasses.search_all_captions_for_product
    @glasses_comments = Glasses.search_all_comments_for_product
  end

  def comment_data
    respond_with Glasses.comments_metadata
  end

end
