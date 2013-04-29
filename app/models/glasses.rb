class Glasses < ActiveRecord::Base
  attr_accessible :name, :image, :color, :collection, :optical, :sku, :male, :female, :active
  require 'nokogiri'
  require 'open-uri'
  scope :optical, where(:optical => true)
  scope :sunwear, where(:optical => false)
  scope :all, where(:optical => (true || false))
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

end
