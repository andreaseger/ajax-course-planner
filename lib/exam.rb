require 'json'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'

class Exam < Hash
  extend Buildable
  include HasKey
  class << self; attr_accessor :namespace end
  @namespace = self.name.downcase
  def namespace
    self.class.namespace
  end

  def save
    $redis.multi do
      $redis.set db_key, to_json
      $redis.sadd "#{namespace}:by_course:#{self[:course][:name]}", key
    end
  end

  def db_key
    "#{namespace}:#{key}"
  end
  def self.db_key(key)
    "#{namespace}:#{key}"
  end
  def self.find id
    from_json $redis.get(self.db_key(id))
  end
  def self.find_by_course course
    $redis.smembers("#{namespace}:by_course:#{course}").map {|k| find k }
  end
end
