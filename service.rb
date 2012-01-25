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


  def json(data)
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
      b = Booking.find(hash)
      json b
    end
  end

  get '/schedule/*', '/s/*' do
    bookings = params[:splat].first.split('/')
    @api_urls = bookings.map{|e| url("/api/b/#{e}")}.to_json if bookings
    mustache :site
  end
  get '/bookings/g/:group' do |group|
    bookings = Booking.keys_by_group(group)
    @api_urls = bookings.map{|e| url("/api/b/#{e}")}.to_json if bookings
    mustache :site
  end
end
