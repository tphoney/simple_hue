require 'puppet/provider/hue'

Puppet::Type.type(:hue_light).provide(:rest, :parent => Puppet::Provider::Hue) do
  confine :feature => :posix
  defaultfor :feature => :posix

  mk_resource_methods

  def self.instances
    instances = []
    lights = Puppet::Provider::Hue.hue_get('lights')

    return [] if lights.nil?

    lights.each do |light|
      instances << new(:name => light.first,
                       :on => light.last['state']['on'].to_s,
                       :bri => light.last['state']['bri'].to_s,
                       :hue => light.last['state']['hue'].to_s)
    end

    instances
  end

  def flush
    name = @original_values[:name]
    @property_hash = @property_hash.reject { |k, _v| !resource[k] }
    @property_hash.delete(:name)
    @property_hash[:hue] = @property_hash[:hue].to_i
    @property_hash[:bri] = @property_hash[:bri].to_i
    Puppet::Provider::Hue.hue_put("lights/#{name}/state", @property_hash)
  end

  def create
    raise('Create not supported.')
  end

  def destroy
    notice('Destroy not supported.')
  end
end
