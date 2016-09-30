require 'json'
require 'uri'
require 'faraday'
# This is the base class on which other providers are based.

class Puppet::Provider::Hue < Puppet::Provider
  def initialize(value = {})
    super(value)
    @original_values = if value.is_a? Hash
                         value.clone
                       else
                         {}
                       end
    @create_elements = false
  end

  def self.prefetch(resources)
    nodes = instances
    resources.keys.each do |name|
      if provider = nodes.find { |node| node.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def self.connection
    if ENV['HUE_IP'].nil?
      raise('HUE_IP environment variable is not set, set using \'export HUE_IP=1.1.1.1\' where 1.1.1.1 is the ip of your hue hub')
    else
      hue_ip = ENV['HUE_IP']
    end
    if ENV['HUE_KEY'].nil?
      raise('HUE_KEY environment variable is not set, set using \'export HUE_KEY=key_thing\' where key_thing is a developer key for your hue hub')
    else
      hue_key = ENV['HUE_KEY']
    end
    @connection = Faraday.new(:url => "http://#{hue_ip}/api/#{hue_key}", :ssl => { :verify => false })
  end

  def self.hue_get(url, args = nil)
    url = URI.escape(url) if url
    result = connection.get(url, args)
    output = JSON.parse(result.body)
  rescue JSON::ParserError
    return nil
  end

  def self.hue_put(url, message)
    message = message.to_json
    message.gsub!(/"false"/, 'false')
    message.gsub!(/"true"/, 'true')
    connection.put(url, message)
  end
end
