# frozen_string_literal: true

require 'flexipass/version'
require 'flexipass/configuration'
require 'flexipass/client'
require 'flexipass/mobile_key'
require 'flexipass/door'
require 'flexipass/company'
require 'flexipass/api_error'

module Flexipass
  # The main module for Flexipass gem.
  #
  # This module provides configuration options for Flexipass.
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  # Configures Flexipass with the given options.
  #
  # Example:
  # Flexipass.configure do |config|
  #   config.username = 'your_username'
  #   config.password = 'your_password'
  #   config.company_token = 'your_company_token'
  #   config.environment = :development # or :production
  #   config.enable_logging = true # optional, defaults to false
  # end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
