# A sample Gemfile
source "https://rubygems.org"

gem 'rack'#, :git => 'git://github.com/rack/rack.git'
gem 'rake'

gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'mustache', :require => 'mustache/sinatra'
gem 'activesupport', :require => false

gem 'puma', require: false
gem 'unicorn', :require => false
gem 'redis'
gem 'nokogiri'
gem 'redcarpet'

gem 'awesome_print'
gem 'colorize'

gem 'whenever',:require => false

group :assets do
  gem 'therubyracer'
  gem 'sprockets'
  gem 'coffee-script'
  gem 'sass'
  gem 'uglifier', :require => false
  gem 'yui-compressor', :require => false
  gem 'susy', :git => 'git://github.com/ericam/susy.git', :require => false
  #gem 'compass-susy-plugin', :require => 'susy'
  gem 'compass', :git => 'git://github.com/chriseppstein/compass.git', :require => false
end

group :development do
  gem 'capistrano'
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
  gem 'guard-sprockets2'
  #gem 'compass-h5bp'
  gem 'guard-livereload'
end

group :development, :test do
  gem 'sqlite3'
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'mocha'
  gem 'guard-rspec'
  gem 'vcr', '>= 2.0.0.rc1'
  gem 'fakeweb'
end
