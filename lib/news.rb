require 'json'
require 'set'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'
require 'active_support/core_ext/hash/diff'

class News < Hash
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
      self[:people].each do |person|
        $redis.sadd "#{namespace}:by_person:#{person[:name]}", key
        $redis.sadd "people", person[:code]
      end
    end
    self
  end

  def db_key
    "#{namespace}:#{key}"
  end
  def self.db_key(key)
    "#{namespace}:#{key}"
  end
  def self.find key
    from_json $redis.get(db_key(key))
  end

  def self.find_by_person person
    $redis.smembers("#{namespace}:by_person:#{person}").map {|k| find k }
  end
  def self.find_by_people people
    keys = Set.new people.map{|person| $redis.smembers("#{namespace}:by_person:#{person}") }.flatten
    keys.map! {|e| db_key(e) }
    $redis.mget(*keys).inject([]) do |a,json|
      a << from_json(json)
    end
  end
  def self.delete_all
    $redis.del *$redis.keys("#{@namespace}*"), "person"
  end
private
  def self.before_create hash
    %w(expire publish).each do |e|
     hash[e] = Time.parse(hash[e]) if hash[e].is_a?(String)
    end
    hash
  end
end
