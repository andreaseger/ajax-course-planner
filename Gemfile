# A sample Gemfile
source "https://rubygems.org"

gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'mustache'

gem 'unicorn'
gem 'redis'
gem 'nokogiri'

group :production do
  gem 'hiredis'
end
group :development do
  gem 'capistrano'
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
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
