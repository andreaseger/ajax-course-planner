module Buildable
  def from_hash hash
    self[hash.recursively_symbolize_keys!] if hash
  end
  def from_json json
    from_hash(JSON.parse(json)) if json
  end
end
