# require 'spec_helper'
# require 'flexipass/client'
# require 'flexipass/configuration'
require 'logger'

RSpec.describe Flexipass::Client do
  let(:username) { 'test_username' }
  let(:password) { 'test_password' }
  let(:company_token) { 'test_company_token' }
  let(:logger) { instance_double(Logger) }
  let(:server_address) { 'https://dev.flexipass.it' }

  before do
    Flexipass.configuration = Flexipass::Configuration.new
    Flexipass.configuration.username = username
    Flexipass.configuration.password = password
    Flexipass.configuration.company_token = company_token
    Flexipass.configuration.enable_logging = false
    allow(Flexipass.configuration).to receive(:validate!)
  end

  describe '#initialize' do
    it 'initializes the Faraday connection' do
      expect(Flexipass.configuration).to receive(:validate!)

      client = Flexipass::Client.new
      conn = client.instance_variable_get(:@conn)

      expect(conn.url_prefix.to_s).to eq(server_address+"/")
    end

    context 'when logging is enabled' do
      before do
        Flexipass.configuration.enable_logging = true
        allow(Logger).to receive(:new).and_return(logger)
        allow(logger).to receive(:level=)
      end

      it 'sets up the logger' do
        expect(Logger).to receive(:new).with(STDOUT).and_return(logger)
        expect(logger).to receive(:level=).with(Logger::DEBUG)

        client = Flexipass::Client.new
        conn = client.instance_variable_get(:@conn)

        expect(conn.builder.handlers).to include(Faraday::Response::Logger)
      end
    end
  end

  describe '#send_request' do
    let(:client) { Flexipass::Client.new }
    let(:endpoint) { '/test_endpoint' }
    let(:params) { { key: 'value' } }
    let(:response_body) { { result: 'success' }.to_json }
    let(:status) { 200 }

    before do
      stub_request(:any, "#{server_address}#{endpoint}?companyToken=#{company_token}")
        .to_return(status: status, body: response_body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'sends a GET request and handles the response' do
      response = client.send_request('GET', endpoint)

      expect(response).to eq('result' => 'success')
      expect(WebMock).to have_requested(:get, "#{server_address}#{endpoint}")
        .with(query: { 'companyToken' => company_token })
    end

    it 'sends a POST request with body and handles the response' do
      response = client.send_request('POST', endpoint, params)

      expect(response).to eq('result' => 'success')
      expect(WebMock).to have_requested(:post, "#{server_address}#{endpoint}")
        .with(query: { 'companyToken' => company_token }, body: params.to_json)
    end

    context 'when the response status is not successful' do
      let(:status) { 500 }
      let(:response_body) { 'Internal Server Error' }

      it 'raises an ApiError' do
        expect {
          client.send_request('GET', endpoint)
        }.to raise_error(Flexipass::ApiError, "API request failed with status #{status}: #{response_body}")
      end
    end
  end

  describe '#basic_auth_header' do
    let(:client) { Flexipass::Client.new }

    it 'returns the correct basic auth header' do
      expected_header = "Basic #{Base64.strict_encode64("#{username}:#{password}")}"

      expect(client.send(:basic_auth_header)).to eq(expected_header)
    end
  end
end
