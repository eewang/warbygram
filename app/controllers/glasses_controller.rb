class GlassesController < ApplicationController
  def index
  	@glasses = Glasses.all
  end
end
