require 'spec_helper_acceptance'

describe 'moda launch with minimal config' do

  before(:all) do
    @result = PuppetManifest.new.execute
  end

  it 'should have execute the manifest' do
    expect(@result).to eq(0)
  end
end
