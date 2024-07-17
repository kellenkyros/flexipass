# spec/flexipass/configuration_spec.rb

require 'spec_helper'
require 'flexipass/configuration'

RSpec.describe Flexipass::Configuration do
  describe '#initialize' do
    it 'sets the default environment to :development' do
      config = Flexipass::Configuration.new
      expect(config.environment).to eq(:development)
    end
  end

  describe '#environment=' do
    it 'updates the environment and server address to :development' do
      config = Flexipass::Configuration.new
      config.environment = :development
      expect(config.environment).to eq(:development)
      expect(config.server_address).to eq(Flexipass::Configuration::DEV_SERVER)
    end

    it 'updates the environment and server address to :production' do
      config = Flexipass::Configuration.new
      config.environment = :production
      expect(config.environment).to eq(:production)
      expect(config.server_address).to eq(Flexipass::Configuration::PROD_SERVER)
    end
  end

  describe '#validate!' do
    it 'raises an error if username is not set' do
      config = Flexipass::Configuration.new
      expect { config.validate! }.to raise_error(Flexipass::ConfigurationError, 'Username must be set')
    end

    it 'raises an error if password is not set' do
      config = Flexipass::Configuration.new
      config.username = 'user'
      expect { config.validate! }.to raise_error(Flexipass::ConfigurationError, 'Password must be set')
    end

    it 'raises an error if company token is not set' do
      config = Flexipass::Configuration.new
      config.username = 'user'
      config.password = 'password'
      expect { config.validate! }.to raise_error(Flexipass::ConfigurationError, 'Company token must be set')
    end

    it 'raises an error for an invalid environment during validation' do
      config = Flexipass::Configuration.new
      config.username = 'user'
      config.password = 'password'
      config.company_token = 'token'
      config.environment = :invalid_env
      expect { config.validate! }.to raise_error(Flexipass::ConfigurationError, 'Invalid environment: invalid_env. Must be :development or :production')
    end

    it 'does not raise an error if all required attributes are set' do
      config = Flexipass::Configuration.new
      config.username = 'user'
      config.password = 'password'
      config.company_token = 'token'
      expect { config.validate! }.not_to raise_error
    end
  end
end
