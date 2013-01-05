require 'nokogiri'
require 'date'
require 'awesome_print'
require 'pry'

def parse(xml)
  h ={}
  h[:telop] = xml.xpath("//telop").children.first.to_s
  h[:temperature_max] = xml.xpath("//temperature//max//celsius").children.first.to_s
  h[:temperature_min] = xml.xpath("//temperature//min//celsius").children.first.to_s
  h[:description] = xml.xpath("//description").children.first.to_s
  h[:date] = Date.parse(xml.xpath("//forecastdate").children.first.to_s)
  h
end

xml = File.open("sample.xml") { |f| Nokogiri::XML(f) }

weather = xml.child.children
h = parse xml
p h

