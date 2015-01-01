天気予報(Livedoor Weather Web Service)をiPhoneへPush通知するコードです。

## 前準備
iPhoneへのPush通知に im.kayac.com を利用します。事前にiPhoneアプリのダウンロードと、登録が必要になります。

* http://im.kayac.com/

Ruby 2.2.0 で動作確認しています。

## 実行方法
* $ bundle install
* $ pit set im-kayac

~/.pit/default.yml

```
im-kayac:
  user: name
  pass: password
```

* $ ruby weather.rb

## 定期実行(毎日5:55に実行する例)
* $ crontab -e

```
55 5 * * * /home/igaiga/.rbenv/shims/ruby /home/igaiga/work/weather/weather.rb
```
