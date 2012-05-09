require 'settings'
require 'bundler'

rack_env = ENV['RACK_ENV'] || 'development'

Bundler.setup
Bundler.require(:default, rack_env, :assets)
print "#{rack_env}\n".cyan

REDIS_CONFIG =  if ENV['PLANNER_REDIS_URL'] && rack_env == 'production'
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

