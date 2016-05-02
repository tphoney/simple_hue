Puppet::Type.newtype(:hue_light) do

  apply_to_device

  newparam(:name) do
    desc "The light name"
    isnamevar
  end

  newproperty(:on) do
    desc "is the light on"
  end

  newproperty(:reachable) do
    desc "is the light reachable"
  end

end
