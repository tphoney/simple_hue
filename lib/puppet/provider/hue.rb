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
      hue_ip = '10.64.12.130'
    else
      hue_ip = ENV['HUE_IP']
    end
    if ENV['HUE_KEY'].nil?
      hue_key = 'FuTWCAwnFqxVSza243gcP-g71U1jZZAeg-iXyH3v'
    else
      hue_key = ENV['HUE_KEY']
    end
    @connection = Faraday.new(:url => "http://#{hue_ip}/api/#{hue_key}", :ssl => { :verify => false }) do |builder|
    #@connection = Faraday.new(:url => 'http://192.168.0.2/api/AVsa-nKtZOlssVKhBwM9MBVTVVUo11nSsGQPIm55', :ssl => { :verify => false }) do |builder|
      builder.request :retry,         :max => 10,
                                      :interval            => 0.05,
                                      :interval_randomness => 0.5,
                                      :backoff_factor      => 2,
                                      :exceptions          => [
                                        Faraday::Error::TimeoutError,
                                        Faraday::ConnectionFailed,
                                        Errno::ETIMEDOUT,
                                        'Timeout::Error',
                                      ]
      builder.adapter :net_http
    end
  end

  def self.call(url, args = nil)
    url = URI.escape(url) if url
    result = connection.get(url, args)
    output = JSON.parse(result.body)
  rescue JSON::ParserError
    return nil
  end

  def self.put(url, message)
    message = message.to_json
    message.gsub!(/"false"/, 'false')
    message.gsub!(/"true"/, 'true')
    connection.put(url, message)
  end
end
