require_relative 'lib/booking'
require_relative 'lib/bookings_parser'
require_relative 'lib/templates'

class CoursePlanner < Sinatra::Base
  configure do |c|
    register Sinatra::Contrib
    register Sinatra::Flash
    register Mustache::Sinatra
    require './views/layout'

    set :mustache, {
      templates: File.dirname(__FILE__) + '/templates',
      views: File.dirname(__FILE__) + '/views',
      namespace: CoursePlanner
    }

    set :public_folder, File.dirname(__FILE__) + '/public'
    enable :sessions
    $redis = Redis.new(REDIS_CONFIG)
  end

  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.tb"
  end


  def json(data)
    content_type 'application/javascript'
    data.to_json
  end

  get '/' do
    mustache :site
  end

  get '/templates.json' do
    json({ templates: templates, partials: partials })
  end

  namespace '/api' do
    get '/s/*' do
      bookings = params[:splat].first.split('/')
      json bookings.map { |e| Booking.find(e) }.compact.map{|b| b.merge(key: b.key)}
    end
    get '/b/g/:group' do |group|
      json Booking.find_by_group(group).map{|b| b.merge(key: b.key)}
    end
    get '/b/c/:course' do |course|
      json Booking.find_by_course(course).map{|b| b.merge(key: b.key)}
    end

    get '/b/:hash' do |hash|
      b = Booking.find(hash)
      json b.merge(key: b.key)
    end

    get '/g' do
      json( groups: $redis.keys('*by_group*').map{|e| e.split(':').last }.compact.sort )
    end
  end

  get '/schedule/*', '/s/*' do
    @api_url = url("/api/s/#{params[:splat].first}")
    mustache :site
  end
  get '/bookings/g/:group' do |group|
    @group = group
    @api_url = "/api/b/g/#{group}" if group
    mustache :site
  end
  get '/bookings/c/:course' do |course|
    @api_url = url("/api/b/c/#{course}") if course
    mustache :site
  end
end
