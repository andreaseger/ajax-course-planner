require 'json'
require_relative 'recursivly_symbolize_keys'
require_relative 'buildable'
require_relative 'has_key'
class Exam < Hash
  extend Buildable
  include HasKey
  def save
    raise "NotYetImplemented"
  end
  def self.find key
    raise "NotYetImplemented"
  end
  class << self
    [:examiner, :course].each do |arg|
      method_name = ("find_by_" + arg.to_s).to_sym
      define_method(method_name) do |key|
        $redis.smembers("exams:by_#{arg.to_s}:#{key}").map {|k| find k }
      end
    end
  end
end
