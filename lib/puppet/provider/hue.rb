require 'puppet/util/network_device/hue'
require 'puppet/util/network_device/transport/hue'
require 'json'

class Puppet::Provider::Hue < Puppet::Provider

def initialize(value={})
    super(value)
    if value.is_a? Hash
      @original_values = value.clone
    else
      @original_values = Hash.new
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

  def self.transport
    if Puppet::Util::NetworkDevice.current
      #we are in `puppet device`
      Puppet::Util::NetworkDevice.current.transport
    else
      #we are in `puppet resource`
      Puppet::Util::NetworkDevice::Transport::Hue.new(Facter.value(:url))
    end
  end

  def self.connection
    transport.connection
  end

  def self.call(url, args=nil)
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
