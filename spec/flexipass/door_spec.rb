require 'spec_helper'
require 'flexipass/client'
require 'flexipass/door'
require 'date'
require 'debug'

RSpec.describe Flexipass::Door do
  let(:client) { instance_double(Flexipass::Client) }
  let(:door) { described_class.new(client) }


  describe '#list' do

    it 'sends a GET request to list all doors' do
      expect(client).to receive(:send_request).with('GET', '/Flexipass/rest/webapi/getDoorList')
      door.list
    end
  end

end
