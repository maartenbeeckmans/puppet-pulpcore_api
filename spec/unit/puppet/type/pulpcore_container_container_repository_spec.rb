#
# This type spec test is automatically generated
#
# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/pulpcore_container_container_repository'

RSpec.describe 'the pulpcore_container_container_repository type' do
  it 'loads' do
    expect(Puppet::Type.type(:pulpcore_container_container_repository)).not_to be_nil
  end
end
