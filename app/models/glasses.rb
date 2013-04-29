class Glasses < ActiveRecord::Base
  attr_accessible :name, :type, :gender, :image
  require 'nokogiri'
  require 'open-uri'

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

  def reg_exp_search
    # convert the glasses name into a regular expression to search the tag list, captions and comments for
  end

  def get_tag_variations
    ["upcase", "downcase", "capitalize"].collect do |variant|
      self.name.send(variant)
    end
  end

  def caption_search_for_product
    photos = []
    self.get_tag_variations.each do |tag|
      tag_regexp = /#{tag}/
      photos << Photo.all.collect do |photo| 
        if photo.caption =~ tag_regexp 
          [photo.id, tag, photo.caption]
        end
      end
    end
    photos.flatten!.delete_if { |item| item.nil? }
    photos
  end

  def self.search_all_captions_for_product
    array = []
    glasses = Glasses.all
    glasses.collect do |glass|
      array[glasses.index(glass)] ||= glass.caption_search_for_product
    end
    array.delete_if { |item| item.empty? }
  end

  def tag_exists?
    tag_check = self.name
    all_tags = Tag.all.collect { |t| t.name }
    if all_tags.include?(tag_check.downcase)
      return true
    end
  end

end
