require 'json'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'

class Booking < Hash
  extend Buildable
  include HasKey
  def save
    $redis.multi do
      $redis.set key, to_json

      self[:teachers].each do |teacher|
        $redis.sadd "bookings:by_teacher:#{teacher[:name]}", key
        $redis.sadd "teachers", teacher[:name]
      end
      [:room, :group, :course].each do |arg|
        name = self[arg][:name]
        $redis.sadd "bookings:by_#{arg}:#{name}", key
        $redis.sadd "#{arg}s", name
      end
    end
  end
  def self.find key
    from_json $redis.get(key)
  end
  class << self
    [:teacher, :group, :course, :room].each do |arg|
      method_name = ("find_by_" + arg.to_s).to_sym
      define_method(method_name) do |key|
        $redis.smembers("bookings:by_#{arg.to_s}:#{key}").map {|k| find k }
      end
    end
  end
end
