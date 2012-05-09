require 'sinatra/base'
module Sinatra
  module StructureHelper
    def days
      @days ||= %w(mo di mi do fr).zip(%w(Montag Dienstag Mittwoch Donnerstag Freitag))
    end

    def index_for_day(day)
      days.index{|e| e[0] == day}
    end
    def label_for_day(i)
      days[i][0]
    end
    def name_for_day(i)
      days[i][1]
    end

    def index_for_time(time)
      @times ||= { "0815" => 0, "1000" => 1, "1145" => 2, "1330" => 3, "1400" => 3, "1430" => 3, "1515" => 4, "1545" => 4, "1615" => 4, "1700" => 5, "1730" => 5, "1845" => 6 }
      @times[time.gsub(':','')]
    end
    def timeslot i
      @slots ||= %w(08:15 10:00 11:45 13:30 15:15 17:00 18:45).zip(%w(09:45 11:30 13:15 15:00 16:45 18:30 20:15))
      { label: @slots[i][0].gsub(':',''),
        name: @slots[i][0],
        text: "#{@slots[i][0]} - #{@slots[i][1]}", 
        days: (0..4).map{|e| {label: label_for_day(e).to_s, bookings: [] } }
      }
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
            a[i][:times][j] ||= {label: timeslot(j), name: time, bookings: []}
            a[i][:times][j][:bookings] << e
            a
          }.each{|e| e[:times].compact! unless e.nil? }
        }
      when :table_by_times
        { times: bookings.reduce([]) { |a,e|
            day = e[:timeslot][:day][:name]
            time = e[:timeslot][:label]
            end_time = e[:timeslot][:end_label]
            j = index_for_day day
            i = index_for_time time
            a[i] ||= timeslot(i)
            a[i][:days][j][:bookings] << e
            a
          }
        }
      end
    end

    def build_newslist(news)
      {
        news: news.map{ |n|
          {
            subject: n[:subject],
            people: n[:people],
            text: markdown(n[:text]),
            published: n[:publish].strftime('%A, %b %d')
          }
        }
      }
    end
  end
end
