require './env'
require 'bundler'

rack_env = ENV['RACK_ENV'] || 'production'

Bundler.setup
Bundler.require(:default, rack_env, :assets)

REDIS_CONFIG =  if ENV['PLANNER_REDIS_URL']
                  require 'uri'
                    uri = URI.parse ENV['PLANNER_REDIS_URL']
                      {
                        host: uri.host,
                        port: uri.port,
                        password: uri.password,
                        db: uri.path.gsub(/^\//, '')
                      }
                else
                  {}
                end
require './service'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/images'
  environment.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
  environment.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets/compass"
  environment.append_path "#{Gem.loaded_specs['compass-susy-plugin'].full_gem_path}/sass"

  run environment
end

map '/' do
  run CoursePlanner.new
end
