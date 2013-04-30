class GlassesController < ApplicationController
  def index
    @glasses_captions = Glasses.search_all_captions_for_product
    @glasses_comments = Glasses.search_all_comments_for_product
  end


end
