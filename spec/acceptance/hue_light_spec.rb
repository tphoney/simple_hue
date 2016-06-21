require 'spec_helper_acceptance'

#describe 'should query the hue_light' do
#  # there is at least one light visible
#end

describe 'should set the hue_light' do
  # turn the light on before testing
  it 'turn the light off' do
    pp = <<-EOS
hue_light { '1':
  on => 'off',
}
EOS
    apply_manifest(pp, :catch_failures => true)
  end
end
