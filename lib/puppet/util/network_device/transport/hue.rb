require 'puppet/util/network_device'
require 'puppet/util/network_device/transport'
require 'puppet/util/network_device/transport/base'

class Puppet::Util::NetworkDevice::Transport::Hue < Puppet::Util::NetworkDevice::Transport::Base
  attr_reader :connection

  def initialize(url, _options = {})
    require 'uri'
    require 'faraday'
    @connection = Faraday.new(:url => url, :ssl => { :verify => false }) do |builder|
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
end
