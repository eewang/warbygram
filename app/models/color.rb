class Color < ActiveRecord::Base
  attr_accessible :cc, :color, :color_assignment, :color_family
  has_many :glasses_colors
  has_many :glasses, :through => :glasses_colors

end
