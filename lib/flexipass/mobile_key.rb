module Flexipass
  class MobileKey
    def initialize(client)
      @client = client
    end

    def create(params)
      validate_params(params)
      @client.send_request('POST', '/Flexipass/rest/webapi/createMobileKey', params)
    end

    def update(mobile_key_id, params)
      validate_params(params)
      @client.send_request('PUT', "/Flexipass/rest/webapi/updateMobileKey?mkID=#{mobile_key_id}", params)
    end

    def delete(mobile_key_id)
      @client.send_request('DELETE', "/Flexipass/rest/webapi/deleteMobileKey?mkID=#{mobile_key_id}")
    end

    def list(door, params)
      validate_list_params(params)
      params[:Door] = door
      @client.send_request('POST', "/Flexipass/rest/webapi/getMobileKeyList", params)
    end

    def details(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/getMobileKeyDetails?mkID=#{mobile_key_id}")
    end

    def send_mail(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/sendMail?mkID=#{mobile_key_id}")
    end

    def send_sms(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/sendSMS?mkID=#{mobile_key_id}")
    end

    private

    def validate_params(params)
      required_params = [:Name, :Surname, :Mail, :Door, :Checkin_date, :Checkin_time, :Checkout_date, :Checkout_time, :MobileKeyType]
      missing_params = required_params - params.keys.map(&:to_sym)
      raise ArgumentError, "Missing required parameters: #{missing_params.join(', ')}" if missing_params.any?

      validate_date_time(params[:Checkin_date], params[:Checkin_time], "Check-in")
      validate_date_time(params[:Checkout_date], params[:Checkout_time], "Check-out")

      validate_mobile_key_type(params[:MobileKeyType])
    end

    def validate_date_time(date, time, label)
      date_format = /^(\d{4}-\d{2}-\d{2})$/
      time_format = /^(\d{2}:\d{2}:\d{2})$/

      unless date.match?(date_format) && time.match?(time_format)
        raise ArgumentError, "Invalid #{label} date or time format"
      end
      begin
        DateTime.parse("#{date} #{time}")
      rescue ArgumentError
        raise ArgumentError, "Invalid #{label} date or time format"
      end
    end

    def validate_list_params(params)
      date_time_format = /(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})$/

      unless params[:StartDate].match?(date_time_format)
        raise ArgumentError, "Invalid StartDate format"
      end

      unless params[:EndDate].match?(date_time_format)
        raise ArgumentError, "Invalid EndDate format"
      end
    end

    def validate_mobile_key_type(type)
      unless [0, 1].include?(type)
        raise ArgumentError, "Invalid MobileKeyType. Must be 0 or 1"
      end
    end
  end
end
