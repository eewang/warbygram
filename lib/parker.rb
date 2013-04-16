require 'nokogiri'
require 'open-uri'
require 'pry'

url = "http://www.warbyparker.com"
@doc = Nokogiri::HTML(open(url))

binding.pry