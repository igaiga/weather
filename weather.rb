# -*- coding: utf-8 -*-
# using Livedoor Weather Web Service / LWWS
# http://weather.livedoor.com/weather_hacks/webservice

require 'open-uri'
require 'json'
require 'date'
require 'awesome_print'
require 'pry'


# im-kayac
require 'im-kayac'
require 'pit'
config_im_kayac = Pit.get 'im-kayac'
user = config_im_kayac['user']
password = config_im_kayac['pass']

def parse(json)
  h ={}
  today_forecast = json["forecasts"].select{|day| day["dateLabel"] == '今日'}.first
  h[:telop] = today_forecast["telop"]
  h[:date] = today_forecast["date"]
  h[:temperature_min] = today_forecast["temperature"]["min"]["celsius"] if today_forecast["temperature"]["min"]
  h[:temperature_max] = today_forecast["temperature"]["max"]["celsius"] if today_forecast["temperature"]["max"]
  h
end

def message(h)
  "#{h[:date]}の天気:#{h[:telop]} 気温:#{h[:temperature_max]}℃/#{h[:temperature_min]}℃"
end

url = 'http://weather.livedoor.com/forecast/webservice/json/v1?city=130010'
# city = 130010 : Tokyo
# 地区ID: http://weather.livedoor.com/forecast/rss/primary_area.xml
json_raw = open(url).read
json = JSON.parse(json_raw)
h = parse json

p ImKayac.post(user, message(h), {:password => password})


