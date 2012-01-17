module Buildable
  def from_hash hash
    self[hash].recursively_symbolize_keys!
  end
  def from_json json
    from_hash JSON.parse(json)
  end
end
