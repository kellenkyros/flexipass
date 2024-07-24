module Flexipass
  # Represents a mobile key in the Flexipass system.
  class MobileKey
    # Initializes a new instance of the MobileKey class.
    #
    # @param client [Object] The client object used to communicate with the Flexipass API.
    def initialize(client)
      @client = client
    end

    # Creates a new mobile key.
    #
    # @param params [Hash] The parameters for creating the mobile key.
    # @option params [String] :Name The name of the mobile key holder.
    # @option params [String] :Surname The surname of the mobile key holder.
    # @option params [String] :Mail The email of the mobile key holder.
    # @option params [String] :Door The door associated with the mobile key.
    # @option params [String] :Checkin_date The check-in date of the mobile key.
    # @option params [String] :Checkin_time The check-in time of the mobile key.
    # @option params [String] :Checkout_date The check-out date of the mobile key.
    # @option params [String] :Checkout_time The check-out time of the mobile key.
    # @option params [Integer] :MobileKeyType The type of the mobile key (0 or 1).
    # @raise [ArgumentError] If any required parameters are missing or if the date or time format is invalid.
    def create(params)
      validate_params(params)
      @client.send_request('POST', '/Flexipass/rest/webapi/createMobileKey', params)
    end

    # Updates an existing mobile key.
    #
    # @param mobile_key_id [String] The ID of the mobile key to update.
    # @param params [Hash] The parameters for updating the mobile key.
    # @option params [String] :Name The name of the mobile key holder.
    # @option params [String] :Surname The surname of the mobile key holder.
    # @option params [String] :Mail The email of the mobile key holder.
    # @option params [String] :Door The door associated with the mobile key.
    # @option params [String] :Checkin_date The check-in date of the mobile key.
    # @option params [String] :Checkin_time The check-in time of the mobile key.
    # @option params [String] :Checkout_date The check-out date of the mobile key.
    # @option params [String] :Checkout_time The check-out time of the mobile key.
    # @option params [Integer] :MobileKeyType The type of the mobile key (0 or 1).
    # @raise [ArgumentError] If any required parameters are missing or if the date or time format is invalid.
    def update(mobile_key_id, params)
      validate_params(params)
      @client.send_request('PUT', "/Flexipass/rest/webapi/updateMobileKey?mkID=#{mobile_key_id}", params)
    end

    # Deletes a mobile key.
    #
    # @param mobile_key_id [String] The ID of the mobile key to delete.
    def delete(mobile_key_id)
      @client.send_request('DELETE', "/Flexipass/rest/webapi/deleteMobileKey?mkID=#{mobile_key_id}")
    end

    # Lists mobile keys for a specific door.
    #
    # @param door [String] The door for which to list mobile keys.
    # @param params [Hash] The parameters for listing mobile keys.
    # @option params [String] :StartDate The start date for filtering mobile keys.
    # @option params [String] :EndDate The end date for filtering mobile keys.
    # @raise [ArgumentError] If the date format is invalid.
    def list(door, params)
      validate_list_params(params)
      params[:Door] = door
      @client.send_request('POST', "/Flexipass/rest/webapi/getMobileKeyList", params)
    end

    # Retrieves details of a mobile key.
    #
    # @param mobile_key_id [String] The ID of the mobile key to retrieve details for.
    def details(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/getMobileKeyDetails?mkID=#{mobile_key_id}")
    end

    # Sends an email for a mobile key.
    #
    # @param mobile_key_id [String] The ID of the mobile key to send the email for.
    def send_mail(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/sendMail?mkID=#{mobile_key_id}")
    end

    # Sends an SMS for a mobile key.
    #
    # @param mobile_key_id [String] The ID of the mobile key to send the SMS for.
    def send_sms(mobile_key_id)
      @client.send_request('GET', "/Flexipass/rest/webapi/sendSMS?mkID=#{mobile_key_id}")
    end

    private

    # Validates the parameters for creating or updating a mobile key.
    #
    # @param params [Hash] The parameters to validate.
    # @raise [ArgumentError] If any required parameters are missing or if the date or time format is invalid.
    def validate_params(params)
      required_params = [:Name, :Surname, :Mail, :Door, :Checkin_date, :Checkin_time, :Checkout_date, :Checkout_time, :MobileKeyType]
      missing_params = required_params - params.keys.map(&:to_sym)
      raise ArgumentError, "Missing required parameters: #{missing_params.join(', ')}" if missing_params.any?

      validate_date_time(params[:Checkin_date], params[:Checkin_time], "Check-in")
      validate_date_time(params[:Checkout_date], params[:Checkout_time], "Check-out")

      validate_mobile_key_type(params[:MobileKeyType])
    end

    # Validates the date and time format.
    #
    # @param date [String] The date to validate.
    # @param time [String] The time to validate.
    # @param label [String] The label for the date or time (e.g., "Check-in").
    # @raise [ArgumentError] If the date or time format is invalid.
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

    # Validates the parameters for listing mobile keys.
    #
    # @param params [Hash] The parameters to validate.
    # @raise [ArgumentError] If the date format is invalid.
    def validate_list_params(params)
      date_time_format = /(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})$/

      unless params[:StartDate].match?(date_time_format)
        raise ArgumentError, "Invalid StartDate format"
      end

      unless params[:EndDate].match?(date_time_format)
        raise ArgumentError, "Invalid EndDate format"
      end
    end

    # Validates the mobile key type.
    #
    # @param type [Integer] The mobile key type.
    # @raise [ArgumentError] If the mobile key type is invalid.
    def validate_mobile_key_type(type)
      unless [0, 1].include?(type)
        raise ArgumentError, "Invalid MobileKeyType. Must be 0 or 1"
      end
    end
  end
end
