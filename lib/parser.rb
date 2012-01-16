require_relative 'parsing'
require_relative 'structure'
class Parser
  include Parsing
  include Structure

  def self.run
    parser = new
    parser.update_bookings
  end
end
