require 'spec_helper'
require 'flexipass/client'
require 'flexipass/company'
require 'date'
require 'debug'

RSpec.describe Flexipass::Company do
  let(:client) { instance_double(Flexipass::Client) }
  let(:company) { described_class.new(client) }


  describe '#details' do

    it 'sends a GET request to fetch company details' do
      expect(client).to receive(:send_request).with('GET', '/Flexipass/rest/webapi/getCompanyDetails')
      company.details
    end
  end

  describe '#permissions' do

    it 'sends a GET request to fetch company permissions' do
      expect(client).to receive(:send_request).with('GET', '/Flexipass/rest/webapi/getPermissionList')
      company.permissions
    end
  end

end
