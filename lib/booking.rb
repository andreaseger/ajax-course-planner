require 'json'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'

class Booking < Hash
  extend Buildable
  include HasKey
  class << self; attr_accessor :namespace end
  @namespace = self.name.downcase
  def namespace
    self.class.namespace
  end

  def save
    $redis.multi do
      $redis.set key, to_json
      self[:teachers].each do |teacher|
        $redis.sadd "#{namespace}:by_teacher:#{teacher[:name]}", key
        $redis.sadd "teacher", teacher[:name]
      end
      [:room, :group, :course].each do |arg|
        name = self[arg][:name]
        $redis.sadd "#{namespace}:by_#{arg}:#{name}", key
        $redis.sadd "#{arg.to_s}", name
      end
    end
  end
  def self.find id
    from_json $redis.get(id)
  end
  class << self
    [:examiner, :group, :course, :room].each do |arg|
      method_name = ("find_by_" + arg.to_s).to_sym
      define_method(method_name) do |id|
        $redis.smembers("#{namespace}:by_#{arg.to_s}:#{id}").map {|k| find k }
      end
    end
  end
end
