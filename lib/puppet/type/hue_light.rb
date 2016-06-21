Puppet::Type.newtype(:hue_light) do
  newparam(:name) do
    desc 'The light name'
    isnamevar
  end

  newproperty(:on) do
    desc 'is the light on'
  end

  newproperty(:ip) do
    desc 'ip of the hue_hub'
  end

  newproperty(:developer_key) do
    desc 'developer key'
  end
end
