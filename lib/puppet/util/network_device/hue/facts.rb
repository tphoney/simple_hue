require 'puppet/util/network_device/hue'

class Puppet::Util::NetworkDevice::Hue::Facts

  attr_reader :transport
  def initialize(transport)
    @transport = transport
  end

  def retrieve
    facts = {}
  end

end
