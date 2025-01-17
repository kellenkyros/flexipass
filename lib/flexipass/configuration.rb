# lib/flexipass/configuration.rb

module Flexipass
  # The `Flexipass` module provides configuration options for the Flexipass gem.
  class Configuration
    attr_accessor :username, :password, :company_token, :environment, :enable_logging
    attr_reader :server_address

    DEV_SERVER = 'https://dev.flexipass.it'
    PROD_SERVER = 'https://flexipass.it'

    def initialize
      @environment = :development
      set_server_address
    end

    def environment=(env)
      @environment = env.to_sym
      set_server_address
    end

    # Validates the configuration options.
    # Raises a `ConfigurationError` if any required options are missing or if the environment is invalid.
    def validate!
      raise ConfigurationError, 'Username must be set' if @username.nil?
      raise ConfigurationError, 'Password must be set' if @password.nil?
      raise ConfigurationError, 'Company token must be set' if @company_token.nil?
      raise ConfigurationError, "Invalid environment: #{@environment}. Must be :development or :production" unless [:development, :production].include?(@environment)
    end

    private

    def set_server_address
      @server_address = if @environment == :development
                          DEV_SERVER
                        elsif @environment == :production
                          PROD_SERVER
                        end
    end
  end

  # Custom error class for configuration-related errors.
  class ConfigurationError < StandardError; end
end
