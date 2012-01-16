require 'json'
class Exam < Hash
  def save
    raise "NotYetImplemented"
  end
  def self.from_hash hash
    Exam[hash].recursively_symbolize_keys!
  end
  def self.from_json json
    from_hash JSON.parse(json)
  end
end
