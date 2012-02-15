require_relative 'config/environment'

map '/assets' do
  run @sprockets
end

require_relative 'course_planner'
map '/' do
  run CoursePlanner.new
end
