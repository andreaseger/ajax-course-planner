module Sinatra
  module MyHelper
    def days
      @days ||= %w(mo di mi do fr).zip(%w(Montag Dienstag Mittwoch Donnerstag Freitag))
    end

    def json(data)
      content_type 'application/javascript'
      data.to_json
    end

    def templates
      @templates ||= Dir['templates/client/*'].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) } }
    end

    def index_for_day(day)
      @days.index{|e| e[0] == 'mi'}
    end
    def label_for_day(i)
      days[i][0]
    end
    def name_for_day(i)
      days[i][1]
    end

    def index_for_time(time)
      @times ||= { "0815" => 0, "1000" => 1, "1145" => 2, "1330" => 3, "1430" => 3, "1515" => 4, "1615" => 4, "1700" => 5, "1845" => 6 }
      @times[time.gsub(':','')]
    end

    def build_schedule(bookings, structure)
      case structure
      when :list
        bookings
      when :table_by_days
        { days: bookings.reduce((0..4).map{|e| {label: label_for_day(e), name: name_for_day(e), times: [] } }){ |a,e|
                day = e[:timeslot][:day][:name]
                time = e[:timeslot][:label]
                i = index_for_day day
                j = index_for_time time
                a[i][:times][j] ||= {label: time.gsub(':',''), name: time, bookings: []}
                a[i][:times][j][:bookings] << e
                a
              }.each{|e| e[:times].compact! unless e.nil? }
        }
      when :table_by_times
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
  end
end
