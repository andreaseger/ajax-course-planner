require './lib/booking'

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

  get '/' do
    mustache :index
  end

  get '/schedule/*' do
    bookings = params['splat'].first.split('/')
    @data = bookings.map { |e| Booking.find(e) }.compact
    mustache :schedule
  end

  get '/exams/c/:course(.json)', '/e/c/:course(.json)' do
    Exam.find_by_course(course).to_json
  end
  get '/bookings/g/:group(.json)', '/b/g/:group(.json)' do
    render :json, Booking.find_by_group(group)
  end
  get '/bookings/c/:course(.json)', '/b/c/:course(.json)' do
    render :json, Booking.find_by_course(course)
  end
end
