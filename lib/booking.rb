# monkey patching Hash and Array
# http://snippets.dzone.com/posts/show/12019
class Hash
  def recursively_symbolize_keys!
    self.symbolize_keys!
    self.values.each do |v|
      if v.is_a? Hash
        v.recursively_symbolize_keys!
      elsif v.is_a? Array
        v.recursively_symbolize_keys!
      end
    end
    self
  end
end

class Array
  def recursively_symbolize_keys!
    self.each do |item|
      if item.is_a? Hash
        item.recursively_symbolize_keys!
      elsif item.is_a? Array
        item.recursively_symbolize_keys!
      end
    end
  end
end

require 'json'
require 'digest/md5'
require 'base64'

class Booking < Hash
  def key
    Base64.urlsafe_encode64(Digest::MD5.digest(to_json))[0,3]
  end

  def self.from_hash hash
    Booking[hash].recursively_symbolize_keys!
  end
  def self.from_json json
    from_hash JSON.parse(json)
  end
end
