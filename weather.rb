# -*- coding: utf-8 -*-
# using Livedoor Weather Web Service / LWWS
# http://weather.livedoor.com/weather_hacks/webservice.html

require 'open-uri'
require 'nokogiri'
require 'date'
require 'awesome_print'
require 'pry'

# im-kayac
require 'im-kayac'
require 'pit'
config_im_kayac = Pit.get 'im-kayac'
user = config_im_kayac['user']
password = config_im_kayac['pass']

def parse(xml)
  h ={}
  h[:telop] = xml.xpath("//telop").children.first.to_s
  h[:temperature_max] = xml.xpath("//temperature//max//celsius").children.first.to_s
  h[:temperature_min] = xml.xpath("//temperature//min//celsius").children.first.to_s
  h[:description] = xml.xpath("//description").children.first.to_s
  h[:date] = Date.parse(xml.xpath("//forecastdate").children.first.to_s)
  h[:city] = xml.xpath("//location").attr('city').value.to_s
  h
end

def message(h)
  "#{h[:date].month}月#{h[:date].day}日の天気:#{h[:telop]} 気温:#{h[:temperature_max]}℃/#{h[:temperature_min]}℃ #{h[:description]}"
end

url = 'http://weather.livedoor.com/forecast/webservice/rest/v1?city=63&day=today'
# city = 63 : Tokyo
# 地区ID: http://weather.livedoor.com/forecast/rss/forecastmap.xml
xml = Nokogiri::XML(open(url).read)
# for sample.xml
# xml = File.open("sample.xml") { |f| Nokogiri::XML(f) }

h = parse xml
p ImKayac.post(user, message(h), {:password => password})


