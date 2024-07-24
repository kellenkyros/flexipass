require 'faraday'
require 'base64'

module Flexipass
  # The Client class is responsible for making API requests to the Flexipass server.
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

    # Returns an instance of the MobileKey class.
    def mobile_key
      @mobile_key ||= MobileKey.new(self)
    end

    # Returns an instance of the Door class.
    def door
      @door ||= Door.new(self)
    end

    # Returns an instance of the Company class.
    def company
      @company ||= Company.new(self)
    end

    # Sends a request to the Flexipass server.
    #
    # @param method [String] The HTTP method for the request.
    # @param endpoint [String] The API endpoint.
    # @param params [Hash] The request parameters.
    # @return [Hash] The parsed JSON response from the server.
    # @raise [ApiError] If the API request fails.
    def send_request(method, endpoint, params = {})
      response = @conn.send(method.downcase) do |req|
        req.url endpoint
        req.params['companyToken'] = Flexipass.configuration.company_token
        req.body = params.to_json if ['POST', 'PUT'].include?(method.upcase)
      end

      handle_response(response)
    end

    private

    # Generates the basic authentication header.
    #
    # @return [String] The basic authentication header.
    def basic_auth_header
      credentials = "#{Flexipass.configuration.username}:#{Flexipass.configuration.password}"
      encoded_credentials = Base64.strict_encode64(credentials)
      "Basic #{encoded_credentials}"
    end

    # Handles the API response.
    #
    # @param response [Faraday::Response] The API response.
    # @return [Hash] The parsed JSON response if the response status is between 200 and 299.
    # @return [String] The response body if the JSON parsing fails.
    # @raise [ApiError] If the response status is not between 200 and 299.
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
