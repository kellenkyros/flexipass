module Flexipass
  class Company
    def initialize(client)
      @client = client
    end

    def details
      @client.send_request('GET', '/Flexipass/rest/webapi/getCompanyDetails')
    end

    def permissions
      @client.send_request('GET', '/Flexipass/rest/webapi/getPermissionList')
    end
  end
end
