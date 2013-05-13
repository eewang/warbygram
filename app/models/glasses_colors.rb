class GlassesColors < ActiveRecord::Base
  attr_accessible :color_id, :glasses_id
  belongs_to :color
  belongs_to :glasses

end
