class GlassesController < ApplicationController
  respond_to :json, :html

  def index
    @glasses_captions = Glasses.search_all_captions_for_product
    @glasses_comments = Glasses.search_all_comments_for_product
  end

  def caption_data
    respond_with Glasses.captions_metadata.sort_by { |i| i[:count] }.reverse
  end

  def comment_data
    respond_with Glasses.comments_metadata.sort_by { |i| i[:count] }.reverse
  end

  def comment_and_caption_data
    respond_with Glasses.comment_and_caption_metadata.sort_by { |i| i[:caption_count] + i[:comment_count] }.reverse
  end

  def warby_related_tags
    respond_with WarbyTag.tag_metadata.sort_by { |i| i[:count] }.reverse
  end

  def new
    # render :text => "testing faye"
  end

end
