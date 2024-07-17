require 'spec_helper'
require 'flexipass/client'
require 'flexipass/mobile_key'
require 'date'
require 'debug'

RSpec.describe Flexipass::MobileKey do
  let(:client) { instance_double(Flexipass::Client) }
  let(:mobile_key) { described_class.new(client) }
  let(:params) do
    {
      Name: 'John',
      Surname: 'Doe',
      Mail: 'john.doe@example.com',
      Door: '101',
      Checkin_date: '2023-01-01',
      Checkin_time: '12:00:00',
      Checkout_date: '2023-01-02',
      Checkout_time: '11:00:00',
      MobileKeyType: 0
    }
  end

  describe '#create' do
    it 'validates params and sends a POST request' do
      expect(mobile_key).to receive(:validate_params).with(params)
      expect(client).to receive(:send_request).with('POST', '/Flexipass/rest/webapi/createMobileKey', params)
      mobile_key.create(params)
    end
  end

  describe '#update' do
    let(:mobile_key_id) { 123 }

    it 'validates params and sends a PUT request' do
      expect(mobile_key).to receive(:validate_params).with(params)
      expect(client).to receive(:send_request).with('PUT', "/Flexipass/rest/webapi/updateMobileKey?mkID=#{mobile_key_id}", params)
      mobile_key.update(mobile_key_id, params)
    end
  end

  describe '#delete' do
    let(:mobile_key_id) { 123 }

    it 'sends a DELETE request' do
      expect(client).to receive(:send_request).with('DELETE', "/Flexipass/rest/webapi/deleteMobileKey?mkID=#{mobile_key_id}")
      mobile_key.delete(mobile_key_id)
    end
  end

  describe '#list' do
  let(:door) { 123 }
  let(:params) { { StartDate: '20240820T0000', EndDate: '20240830T0000' } }

    it 'sends a POST request to list all keys of a door' do
      expect(client).to receive(:send_request).with('POST', '/Flexipass/rest/webapi/getMobileKeyList', params)
      mobile_key.list(door, params)
    end
  end

  describe '#details' do
    let(:mobile_key_id) { 123 }

    it 'sends a GET request' do
      expect(client).to receive(:send_request).with('GET', "/Flexipass/rest/webapi/getMobileKeyDetails?mkID=#{mobile_key_id}")
      mobile_key.details(mobile_key_id)
    end
  end

  describe '#send_mail' do
    let(:mobile_key_id) { 123 }

    it 'sends a GET request to send email' do
      expect(client).to receive(:send_request).with('GET', "/Flexipass/rest/webapi/sendMail?mkID=#{mobile_key_id}")
      mobile_key.send_mail(mobile_key_id)
    end
  end

  describe '#send_sms' do
    let(:mobile_key_id) { 123 }

    it 'sends a GET request to send SMS' do
      expect(client).to receive(:send_request).with('GET', "/Flexipass/rest/webapi/sendSMS?mkID=#{mobile_key_id}")
      mobile_key.send_sms(mobile_key_id)
    end
  end

  describe '#validate_params' do
    context 'when required params are missing' do
      it 'raises an ArgumentError' do
        params.delete(:Name)
        expect { mobile_key.send(:validate_params, params) }.to raise_error(ArgumentError, 'Missing required parameters: Name')
      end
    end

    context 'when date or time format is invalid' do
      it 'raises an ArgumentError for check-in date' do
        params[:Checkin_date] = 'invalid_date'
        expect { mobile_key.send(:validate_params, params) }.to raise_error(ArgumentError, 'Invalid Check-in date or time format')
      end

      it 'raises an ArgumentError for check-out date' do
        params[:Checkout_date] = 'invalid_date'
        expect { mobile_key.send(:validate_params, params) }.to raise_error(ArgumentError, 'Invalid Check-out date or time format')
      end
    end

    context 'when MobileKeyType is invalid' do
      it 'raises an ArgumentError' do
        params[:MobileKeyType] = 2
        expect { mobile_key.send(:validate_params, params) }.to raise_error(ArgumentError, 'Invalid MobileKeyType. Must be 0 or 1')
      end
    end

    context 'when all params are valid' do
      it 'does not raise any errors' do
        expect { mobile_key.send(:validate_params, params) }.not_to raise_error
      end
    end
  end
end
