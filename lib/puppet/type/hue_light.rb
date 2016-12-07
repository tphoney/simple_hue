Puppet::Type.newtype(:hue_light) do
  newparam(:name) do
    desc 'The light name'
    isnamevar
  end

  newproperty(:on) do
    desc 'is the light on'
  end

  newproperty(:hue) do
    desc 'hue of the hue_light'
  end
  newproperty(:bri) do
    desc 'brightness of the hue_light'
  end
end
