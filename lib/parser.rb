require 'net/http'
require "nokogiri"
require_relative 'structure'
class Parser
  include Structure
  def get url
    Timeout::timeout(5) { Net::HTTP.get_response(URI.parse(url)) }
  end

  def get_with_xpath url, xpath
    response = get(url)
    case response.code
    when /^2\d{2}$/
      xml = Nokogiri::XML(response.body)
      return xml.xpath xpath
    else
      return nil
    end
  rescue Exception => e
    raise "[ERROR] get_with_xpath(#{url},#{xpath}) -> #{e.message}\n#{e.backtrace}"
  end

  def self.run
    parser = new
    parser.update_data
  end
end
