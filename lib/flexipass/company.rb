module Flexipass
  # Represents a company in the Flexipass system.
  class Company
    # Initializes a new instance of the Company class.
    #
    # @param client [Object] The client object used to communicate with the Flexipass API.
    def initialize(client)
      @client = client
    end

    # Retrieves the details of the company.
    #
    # @return [Hash] The company details.
    def details
      @client.send_request('GET', '/Flexipass/rest/webapi/getCompanyDetails')
    end

    # Retrieves the permissions list for the company.
    #
    # @return [Array] The list of permissions.
    def permissions
      @client.send_request('GET', '/Flexipass/rest/webapi/getPermissionList')
    end
  end
end
