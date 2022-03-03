#
# This provider spec test is automatically generated
#
# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::PulpcoreContentguardsContainerContentRedirect')
require 'puppet/provider/pulpcore_contentguards_container_content_redirect/pulpcore_contentguards_container_content_redirect'

RSpec.describe Puppet::Provider::PulpcoreContentguardsContainerContentRedirect::PulpcoreContentguardsContainerContentRedirect do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  before(:each) { stub_default_config }

  describe '#get' do
    it 'processes resources' do
      expect(context).to receive(:debug).with('Returning pre-canned example data')
      expect(provider.get(context)).to eq [
        {
          name: 'foo',
          ensure: 'present',
        },
        {
          name: 'bar',
          ensure: 'present',
        },
      ]
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource' do
      expect(context).to receive(:notice).with(%r{\ACreating 'a'})

      provider.create(context, 'a', name: 'a', ensure: 'present')
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(context).to receive(:notice).with(%r{\AUpdating 'foo'})

      provider.update(context, 'foo', name: 'foo', ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      expect(context).to receive(:notice).with(%r{\ADeleting 'foo'})

      provider.delete(context, 'foo')
    end
  end
end
