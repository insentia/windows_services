require 'spec_helper'
describe 'windows_services' do

  context 'with defaults for all parameters' do
    it { should contain_class('windows_services') }
  end
end
