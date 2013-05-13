class Glasses < ActiveRecord::Base
  attr_accessible :name, :image, :color, :collection, :optical, :sku, :male, :female, :active
  require 'nokogiri'
  require 'open-uri'
  scope :optical, where(:optical => true)
  scope :sunwear, where(:optical => false)
  # scope :all, where(:optical => (true || false))

  SPECIAL_TAGS = {
    :liv => /\bliv\b/i
  }

  def self.scrape_glasses(url)
  	doc = Nokogiri::HTML(open(url))

  	doc.css(".products-grid").map do |item|
  		item.css(".item").map do |product|
  			product_name = product.css(".product-name").inner_text.strip
  			product_image = product.at_css(".product-image img")
  			unless product_image.nil?

  				g = Glasses.new(:name => product_name, :image => product_image['src'])
  				g.save

  			end
  		end
  	end
  end

  def self.scrape_navigation
  	doc = Nokogiri::HTML(open('http://www.warbyparker.com'))
  	doc.css("#navmenu li.level-top").map do |subnav|
  		subnav.css("ul.submenu a").each do |link|
  			page = link['href']

  			Glasses.scrape_glasses(page)

  		end
  	end
  end

  def self.check_for_tags
    tag_array = Glasses.all.collect do |g|
      [g.name, g.tag_count]
    end
  end

  def tag_count
    possible_tags = self.get_tag_variations
    possible_tags.collect do |tag|
      tag_name = Tag.where(:name => tag).first
      tag_count = tag_name ? tag_name.photos.uniq.count : 0
      [tag, tag_count]
    end
  end

  # def get_tag_variations
  #   ["upcase", "downcase", "capitalize"].collect do |variant|
  #     self.name.send(variant)
  #   end
  # end

  def self.unique_glasses
    Glasses.all.uniq { |g| g.name }
  end

  def comment_search_for_product
    comments = []
    tag_regexp = SPECIAL_TAGS[self.name.downcase.to_sym] || /#{self.name}/i
    comments << Comment.all.collect do |comment|
      if comment.comment =~ tag_regexp
        { :comment_id => comment.id, 
          :photo_id => comment.photo_id, 
          :tag => self.name, 
          :comment => comment.comment}
      end
    end
    comments.flatten!.delete_if { |item| item.nil? }
  end

  def caption_search_for_product
    photos = []
    tag_regexp = SPECIAL_TAGS[self.name.downcase.to_sym] || /#{self.name}/i
    photos << Photo.all.collect do |photo| 
      if photo.caption =~ tag_regexp 
        {:photo_id => photo.id, :tag => self.name, :caption => photo.caption}
      end
    end
    photos.flatten!.delete_if { |item| item.nil? }
  end

  def self.search_all_comments_for_product
    array = []
    glasses = Glasses.unique_glasses
    glasses.collect do |glass|
      array[glasses.index(glass)] ||= glass.comment_search_for_product
    end
    array.delete_if { |item| item.empty? }
  end

  def self.search_all_captions_for_product
    array = []
    glasses = Glasses.unique_glasses
    glasses.collect do |glass|
      array[glasses.index(glass)] ||= glass.caption_search_for_product
    end
    array.delete_if { |item| item.empty? }
  end

  def self.comments_metadata
    glasses = Glasses.search_all_comments_for_product.flatten
    unique_glasses = glasses.uniq { |c| c[:tag] }
    array = unique_glasses.collect do |item|
      {:tag => item[:tag], :count => glasses.count { |i| i[:tag] == item[:tag] }}
    end
  end

  def self.captions_metadata
    glasses = Glasses.search_all_captions_for_product.flatten
    unique_glasses = glasses.uniq { |c| c[:tag] }
    array = unique_glasses.collect do |item|
      {:tag => item[:tag], :count => glasses.count { |i| i[:tag] == item[:tag] }}
    end
  end

  def self.comment_and_caption_metadata
    glasses = Glasses.group(:name)
    array = glasses.collect do |item|
      { :tag => item.name, 
        :caption_count => item.caption_search_for_product.size, 
        :comment_count => item.comment_search_for_product.size}
    end
    array.delete_if { |t| t[:caption_count] + t[:comment_count] == 0}
  end

  def tag_exists?
    tag_check = self.name
    all_tags = Tag.all.collect { |t| t.name }
    if all_tags.include?(tag_check.downcase)
      return true
    end
  end

end
