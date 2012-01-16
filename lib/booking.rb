require 'json'
require 'digest/sha1'
require 'base64'

class Booking < Hash
  def key
    Base64.urlsafe_encode64(Digest::SHA1.digest(to_json))[0,5]
  end
  def save
    $redis.multi do
      $redis.set key, to_json

      teachers.each do |teacher|
        $redis.sadd "by_teacher:#{teacher[:name]}", key
        $redis.sadd "teachers", teacher[:name]
      end
      [:room, :group, :course].each do |arg|
        name = send(arg)[:name]
        $redis.sadd "by_#{arg}:#{name}", key
        $redis.sadd "#{arg}s", name
      end
    end
  end

  def self.find(key)
    from_json $redis.get(key)
  end
  class << self
    [:teacher, :group, :course, :room].each do |arg|
      method_name = ("find_by_" + arg.to_s).to_sym
      define_method(method_name) do |key|
        $redis.smembers("by_#{arg.to_s}:#{key}").map {|k| find k }
      end
    end
  end

  def self.from_hash hash
    Booking[hash].recursively_symbolize_keys!
  end
  def self.from_json json
    from_hash JSON.parse(json)
  end
end
