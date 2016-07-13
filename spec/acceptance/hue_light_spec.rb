require 'spec_helper_acceptance'
hue_ip = ENV['HUE_IP']
hue_key = ENV['HUE_KEY']

describe 'should set the hue_light to off and should be idempotent' do
  # turn the light on before testing
  it 'turn the light off' do
    pp = <<-EOS
hue_light { '1':
  on => 'false',
}
EOS
    apply_manifest(pp, {:catch_failures => true,"HUE_IP"=>"#{hue_ip}", "HUE_KEY"=>"#{hue_key}"})
    apply_manifest(pp, {:catch_failures => true,"HUE_IP"=>"#{hue_ip}", "HUE_KEY"=>"#{hue_key}"})
  end

#  it 'turn the light on and change color' do
#    pp = <<-EOS
#hue_light { '1':
#  on  => 'true',
#  hue => '0',
#}
#EOS
#    apply_manifest(pp, :catch_failures => true)
#    apply_manifest(pp, :catch_failures => true)
#  end
#
end
