module Flexipass
  # Represents a door in the Flexipass system.
  class Door
    # Initializes a new instance of the Door class.
    #
    # @param client [Object] The client object used to communicate with the Flexipass API.
    def initialize(client)
      @client = client
    end

    # Retrieves a list of doors
    #
    # @return [Object] The response object containing the list of doors.
    def list
      @client.send_request('GET', '/Flexipass/rest/webapi/getDoorList')
    end
  end
end
