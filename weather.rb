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

def parse_day_forecast(day_forecast)
  h = {}
  h[:telop] = day_forecast["telop"]
  h[:date] = day_forecast["date"]
  h[:temperature_min] = day_forecast["temperature"]["min"]["celsius"] if day_forecast["temperature"]["min"]
  h[:temperature_max] = day_forecast["temperature"]["max"]["celsius"] if day_forecast["temperature"]["max"]
  h
end

def parse(json)
  forecasts = []
  today_forecast = json["forecasts"].select{|day| day["dateLabel"] == '今日'}.first
  tomorrow_forecast = json["forecasts"].select{|day| day["dateLabel"] == '明日'}.first
  forecasts << parse_day_forecast(today_forecast)
  forecasts << parse_day_forecast(tomorrow_forecast)
  forecasts
end

def decolate(h)
  replaces = [["晴れ"," ☀ "], ["晴"," ☀ "], ["曇り", " ☁ "], ["曇", " ☁ "], ["雨", " ☂ "], ["雪", " ☃ "]]
  replaces.each{|e| h[:telop].gsub!(e[0],e[1])}
  h
end

def message_day(h)
  "#{h[:date]}の天気:#{h[:telop]} 気温:#{h[:temperature_max]}℃/#{h[:temperature_min]}℃"
end

url = 'http://weather.livedoor.com/forecast/webservice/json/v1?city=130010'
# city = 130010 : Tokyo
# 地区ID: http://weather.livedoor.com/forecast/rss/primary_area.xml
json_raw = open(url).read
json = JSON.parse(json_raw)
forecasts = parse(json)
p message = forecasts.map{|e| decolate(e)}.map{|e| message_day(e)}.join("\n")
p ImKayac.to(user).password(password).post(message)
