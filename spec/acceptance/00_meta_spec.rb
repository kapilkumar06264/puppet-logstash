# frozen_string_literal: true

require 'spec_helper_acceptance'

# Here we put the more basic fundamental tests, ultra obvious stuff.
describe 'puppet' do
  it 'has an lsbdistdescription fact' do
    expect(fact('lsbdistdescription')).to match(%r{(centos|ubuntu|debian|suse)}i)
  end

  desired_version = PUPPET_VERSION[%r{(\d+\.\d+)}] unless puppet_enterprise?
  desired_version = "Puppet Enterprise #{PE_VERSION[%r{(\d+\.\d+)}]}" if puppet_enterprise?

  it "is version: #{desired_version}.x" do
    actual_version = shell('puppet --version').stdout.chomp
    expect(actual_version).to contain(desired_version)
  end
end

describe 'logstash module' do
  it 'is available' do
    shell(
      "ls #{default['distmoduledir']}/logstash/metadata.json",
      acceptable_exit_codes: 0
    )
  end

  it 'is parsable' do
    shell(
      "puppet parser validate #{default['distmoduledir']}/logstash/manifests/*.pp",
      acceptable_exit_codes: 0
    )
  end
end
