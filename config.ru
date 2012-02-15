$:.unshift File.expand_path("../config",__FILE__)
require 'environment'

map '/assets' do
  run sprockets
end

require './course_planner'
map '/' do
  run CoursePlanner.new
end
