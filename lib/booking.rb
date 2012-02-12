require 'json'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'
require 'active_support/core_ext/hash/diff'

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
      $redis.set db_key, to_json
      $redis.sadd "#{namespace}:by_group:#{self[:group][:name]}", key
      $redis.sadd "group", self[:group][:name]
    end
    self
  end

  def similar?(other)
    one = self.dup
    other = other.dup
    [one, other].each {|e| e.delete(:rooms) }
    one.diff(other).empty?
  end
  def db_key
    "#{namespace}:#{key}"
  end
  def self.db_key(key)
    "#{namespace}:#{key}"
  end
  def self.find key
    from_json $redis.get(self.db_key(key))
  end
  def self.find_by_group group
    $redis.smembers("#{namespace}:by_group:#{group}").map {|k| find k }
  end
end
