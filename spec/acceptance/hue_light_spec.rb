require 'spec_helper_acceptance'
describe 'should change the hue_light' do
  it 'turn the light on and set hue to red' do
    pp = <<-EOS
hue_light { '1':
  bri => '254',
  hue => '0',
  on  => 'true',
}
EOS
    Beaker::TestmodeSwitcher::DSL.execute_manifest(pp, beaker_opts)
    result = Beaker::TestmodeSwitcher::DSL.execute_manifest(pp, beaker_opts)
    # Are we idempotent
    expect(result.exit_code).to eq 0

    # Check puppet resource
    result = Beaker::TestmodeSwitcher::DSL.resource('hue_light', '1', beaker_opts)
    expect(result.stdout).to match(%r{hue => '0'})
    expect(result.stdout).to match(%r{bri => '254'})
    expect(result.stdout).to match(%r{on  => 'true'})
  end

  it 'sets the hue to blue' do
    pp = <<-EOS
hue_light { '1':
  bri => '254',
  hue => '46920',
}
EOS
    Beaker::TestmodeSwitcher::DSL.execute_manifest(pp, beaker_opts)
    result = Beaker::TestmodeSwitcher::DSL.execute_manifest(pp, beaker_opts)
    # Are we idempotent
    expect(result.exit_code).to eq 0

    # Check puppet resource
    result = Beaker::TestmodeSwitcher::DSL.resource('hue_light', '1', beaker_opts)
    match(%r{bri => '254'})
    expect(result.stdout).to match(%r{hue => '46920'})
  end
end
