require 'net/http'
require "nokogiri"
require_relative 'structure'
class Parser
  include Structure

  def get url
    Timeout::timeout(5) do
      net = Net::HTTP.get_response(URI.parse(url))
      raise "HTTP Error: #{net.code}" if %w(404 500).include? net.code
      xml = Nokogiri::XML(net.body)
    end
  end

  def get_with_xpath url, xpath
    xml = get url
    xml.xpath xpath
  rescue Exception => e
    raise "[ERROR] get_with_xpath(#{url},#{xpath}) -> #{e.message}\n#{e.backtrace}"
    #exit 1
  end

  def self.run
    parser = new
    parser.update_data
  end
end
