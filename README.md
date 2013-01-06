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

## RVM を使う場合
* $ ~/.rvm/wrappers/ruby-1.9.3-p362@weather/ruby /path/to/weather.rb

## 定期実行(5:55に実行する例)
* $ crontab -e

```
55 5 * * * ~/.rvm/wrappers/ruby-1.9.3-p362@weather/ruby /path/to/weather.rb
```

