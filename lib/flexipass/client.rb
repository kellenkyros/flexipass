require 'faraday'
require 'base64'

module Flexipass
  class Client
    def initialize
      Flexipass.configuration.validate!
      @conn = Faraday.new(url: Flexipass.configuration.server_address) do |faraday|
        if Flexipass.configuration.enable_logging
          # Create a logger instance
          logger = Logger.new(STDOUT)
          logger.level = Logger::DEBUG
          faraday.response :logger, logger, bodies: true  # Set bodies: true to log request and response bodies
        end
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.headers['Authorization'] = basic_auth_header
      end
    end

    def mobile_key
      @mobile_key ||= MobileKey.new(self)
    end

    def door
      @door ||= Door.new(self)
    end

    def company
      @company ||= Company.new(self)
    end

    def send_request(method, endpoint, params = {})
      response = @conn.send(method.downcase) do |req|
        req.url endpoint
        req.params['companyToken'] = Flexipass.configuration.company_token
        req.body = params.to_json if ['POST', 'PUT'].include?(method.upcase)
      end

      handle_response(response)
    end

    private

    def basic_auth_header
      credentials = "#{Flexipass.configuration.username}:#{Flexipass.configuration.password}"
      encoded_credentials = Base64.strict_encode64(credentials)
      "Basic #{encoded_credentials}"
    end

    def handle_response(response)
      case response.status
      when 200..299
        JSON.parse(response.body)
      else
        raise ApiError.new("API request failed with status #{response.status}: #{response.body}")
      end
    rescue JSON::ParserError
      response.body
    end
  end
end
