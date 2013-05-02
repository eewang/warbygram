class WarbyTag < ActiveRecord::Base
  attr_accessible :tag, :count

  def self.tag_metadata
    WarbyTag.all.collect do |item|
      {:tag => item.tag, :count => item.count}
    end
  end

end
