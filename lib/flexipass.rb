# frozen_string_literal: true

require 'flexipass/version'
require 'flexipass/configuration'
require 'flexipass/client'
require 'flexipass/mobile_key'
require 'flexipass/door'
require 'flexipass/company'
require 'flexipass/api_error'

module Flexipass
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
