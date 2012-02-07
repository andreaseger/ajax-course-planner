require_relative 'lib/booking'
require_relative 'lib/exam'
#require_relative 'lib/templates'

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
    disable :exams

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

  def templates
    @templates ||= Dir['templates/client/*'].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) } }
  end

  get '/' do
    redirect url('bookings/g/ig')
  end

  get '/templates.json' do
    json templates
  end

  def index_for_day(day)
    @days ||= {mo: 0, di: 1, mi: 2, do: 3, fr: 4}
    @days[day.to_sym]
  end
  def label_for_day(i)
    @days ||= {mo: 0, di: 1, mi: 2, do: 3, fr: 4}
    @days.keys[i]
  end
  def index_for_time(time)
    @times ||= { "0815" => 0, "1000" => 1, "1145" => 2, "1330" => 3, "1515" => 4, "1700" => 5, "1845" => 6 }
    @times[time]
  end
  def build_schedule(bookings, structure)
    case structure
    when :list
      bookings
    when :timetable
      { days: bookings.reduce([]){ |a,e|
              day = e[:timeslot][:day][:name]
              time = e[:timeslot][:label]
              i = index_for_day day
              j = index_for_time time
              a[i] ||= {label: day, times: []}
              a[i][:times][j] ||= {label: time, bookings: []}
              a[i][:times][j][:bookings] << e
              a
            }.each{|e| e[:times].compact! unless e.nil? }.compact!
      }
    when :htimetable
      { times: bookings.reduce([]) { |a,e|
              day = e[:timeslot][:day][:name]
              time = e[:timeslot][:label]
              j = index_for_day day
              i = index_for_time time.gsub(':','')
              a[i] ||= {label: time.gsub(':',''), name: time, days: (0..4).map{|e| {label: label_for_day(e).to_s, bookings: [] } } }
              a[i][:days][j][:bookings] << e
              a
            }
      }
    end
  end
  namespace '/api' do
    get '/s' do
      bookings = params[:bookings]
      get_exams = params[:exams]
      structure = params[:structure].try(:to_sym) || :list
      if bookings
        b = bookings.map { |e| Booking.find(e) }.compact.map{|b| b.merge(key: b.key)}
        schedule= build_schedule(b,structure)
        if get_exams && settings.exams
          exams = schedule.map { |e| Exam.find_by_course(e[:course][:name]) }.flatten.compact
          json( bookings: schedule, has_exams: !exams.empty?, exams: exams )
        else
          json( bookings: schedule, has_exams: false )
        end
      end
    end

    get '/b/g/:group' do |group|
      json Booking.find_by_group(group).map{|b| b.merge(key: b.key)}
    end

    get '/g' do
      json( groups: $redis.smembers('group').sort )
    end

    get '/e' do
      courses = params[:courses]
      if courses
        json courses.map {|e| Exam.find_by_course(e) }
      end
    end
  end

  get '/schedule/*' do
    @pagename = "schedule"
    @bookings = params[:splat].first
    mustache :site
  end
  get '/bookings/g/:group' do |group|
    @group = group
    @api_url = "/api/b/g/#{group}" if group
    mustache :site
  end
end
