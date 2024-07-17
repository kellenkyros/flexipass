module Flexipass
  class Door
    def initialize(client)
      @client = client
    end

    def list
      @client.send_request('GET', '/Flexipass/rest/webapi/getDoorList')
    end
  end
end
