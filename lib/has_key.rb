require 'digest/sha1'
require 'base64'
module HasKey
  def key
    Base64.urlsafe_encode64(Digest::SHA1.digest(to_json))
  end
end
