require './lib/booking'
require './lib/bookings_parser'

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


  def jsoe(data)
    content_type 'application/javascript'
    data.to_json
  end


  get '/' do
    mustache :site
  end

  namespace '/api' do
    get '/s/*' do
      bookings = params[:splat].first.split('/')
      json bookings.map { |e| Booking.find(e) }.compact
    end
    get '/b/g/:group' do |group|
      json Booking.find_by_group(group)
    end
    get '/b/c/:course' do |course|
      json Booking.find_by_course(course)
    end

    get '/b/:hash' do |hash|
      json Booking.find(hash)
    end
  end

  get '/schedule/*', '/s/*' do
    @api_url = url("/api/s/#{params[:splat]}")
    mustache :site
  end
  get '/bookings/g/:group' do |group|
    @api_url = url("/api/b/g/#{group}") if group
    mustache :site
  end
  get '/bookings/c/:course' do |course|
    @api_url = url("/api/b/c/#{course}") if course
    mustache :site
  end
end
