require 'puppet/util/network_device'
require 'puppet/util/network_device/hue/facts'
require 'puppet/util/network_device/transport/hue'

class Puppet::Util::NetworkDevice::Hue::Device
  attr_reader :connection
  attr_accessor :url, :transport

  def initialize(url, options = {})
    @autoloader = Puppet::Util::Autoload.new(
      self,
      'puppet/util/network_device/transport'
    )
    if @autoloader.load('hue')
      @transport = Puppet::Util::NetworkDevice::Transport::Hue.new(url, options[:debug])
    end
  end

  def facts
    @facts ||= Puppet::Util::NetworkDevice::Hue::Facts.new(@transport)

    @facts.retrieve
  end
end
