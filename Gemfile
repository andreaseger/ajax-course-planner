# A sample Gemfile
source "https://rubygems.org"

gem 'rack', :git => 'git://github.com/rack/rack.git'
gem 'rake'

gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'mustache', :require => 'mustache/sinatra'
gem 'activesupport', :require => false

gem 'thin'
gem 'redis'
gem 'nokogiri'

group :production do
  gem 'hiredis'
end

group :assets do
  gem 'therubyracer'
  gem 'sprockets'
  gem 'coffee-script'
  gem 'sass'
  gem 'uglifier'
  gem 'compass-susy-plugin', :require => 'susy'
  gem 'compass', ">= 0.12.alpha.1", :require => false
  gem 'compass-h5bp'
end

group :development do
  gem 'capistrano'
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
  gem 'guard-sprockets2'
  gem 'guard-livereload'
  #gem 'compass'
  #gem 'compass-susy-plugin'
  #gem 'guard-compass'
  #gem 'guard-bundler'
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
