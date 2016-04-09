require 'httparty'

module SmsActivate
  class Client
    include HTTParty
    base_uri 'http://sms-activate.ru/stubs/handler_api.php'

    # Initializes a new SmsActivate Client
    #
    # @param [String] api_key The API key, can be obtained at
    #   http://sms-activate.ru/index.php?act=profile
    #
    def initialize(api_key)
      @options = { query: { api_key: api_key } }
    end

    # Returns an amount of available numbers for each service
    #
    # @param [Boolean] full Whether to include "cost" and "quant" keys
    #
    # @example
    #   SmsActivate::Client.new('key').get_available_services
    #   => {"vk_0"=>{"quant"=>"0", "cost"=>10}, ...}
    #
    #   SmsActivate::Client.new('key').get_available_services(false)
    #   => {"vk_0"=>"0", "ok_0"=>"42", ...}
    #
    def get_available_services(full = true)
      action = full ? 'getNumbersStatus1' : 'getNumbersStatus'
      response = self.class.get('/', query: { action: action }.merge(@options[:query]))

      check_errors! response
      JSON.parse(response.parsed_response)
    end

    # Returns user's balance in RUB
    #
    # @example
    #   SmsActivate::Client.new('key').get_balance
    #   => 0.0
    def get_balance
      response = self.class.get('/', query: { action: 'getBalance' }.merge(@options[:query]))

      check_errors! response
      response.parsed_response.split(':')[1].to_f
    end

    # Obtains a number for the given service
    #
    # @example
    #   SmsActivate::Client.new('key').obtain_number('ya')
    #   => OpenStruct id=42 number="+1234567890"
    #
    # TODO: forward, operator
    #
    def obtain_number(service)
      response = self.class.get('/', query: { action: 'getNumber', service: service }.merge(@options[:query]))
      check_errors! response

      splitted = response.parsed_response.split(':')
      OpenStruct.new(id: splitted[1].to_i, number: splitted[2])
    end

    # Sets the status of the activation
    #
    STATUSES = {
        cancelled:   -1, # Cancels the activation
        sms_sent:     1, # Tells that SMS message has been sent to the number
        on_retry:    3,  # Requests one more code (for free)
        finished:    6,  # Finishes the activation
        number_used: 8   # Complains that number is already used and cancels the activation
    }.freeze
    #
    # @example
    #   SmsActivate::Client.new('key').set_activation_status(42, :sms_sent)
    #   => OpenStruct status=:confirmed
    #
    # TODO: forward
    #
    def set_activation_status(id, status)
      raise BadStatusError unless (status = STATUSES[status])
      response = self.class.get('/', query: { action: 'setStatus', id: id, status: status }.merge(@options[:query]))

      check_errors! response
      case response.parsed_response
        when 'ACCESS_READY'
          OpenStruct.new(status: :confirmed)
        when 'ACCESS_RETRY_GET'
          OpenStruct.new(status: :retrying)
        when 'ACCESS_ACTIVATION'
          OpenStruct.new(status: :activated)
        when 'ACCESS_CANCEL'
          OpenStruct.new(status: :cancelled)
        else
          raise ServerError('Bad activation response')
      end
    end

    # Returns the activation status
    #
    # @example
    #   SmsActivate::Client.new('key').get_activation_status(42)
    #   => OpenStruct status=:success code="12345"
    #
    def get_activation_status(id)
      response = self.class.get('/', query: { action: 'getStatus', id: id }.merge(@options[:query]))

      check_errors! response
      case response.parsed_response
        when 'STATUS_WAIT_CODE'
          OpenStruct.new(status: :waiting)
        when 'STATUS_WAIT_RESEND'
          OpenStruct.new(status: :waiting_for_resend)
        when 'STATUS_CANCEL'
          OpenStruct.new(status: :cancelled)
        when /STATUS_WAIT_RETRY/
          OpenStruct.new(status: :waiting_for_code_confirmation, lastcode: response.parsed_response.split(':')[1])
        when /STATUS_OK/
          OpenStruct.new(status: :success, code: response.parsed_response.split(':')[1])
        else
          raise ServerError('Bad activation response')
      end
    end

    private

    def check_errors!(response)
      raise ServerError(response.parsed_response) if response.code != 200

      case response.parsed_response
        when 'NO_KEY'
          raise NoKeyError
        when 'BAD_KEY'
          raise BadKeyError
        when 'NO_ACTION'
          raise NoActionError
        when 'BAD_ACTION'
          raise BadActionError
        when 'ERROR_SQL'
          raise SQLError
        when 'NO_BALANCE'
          raise NoBalanceError
        when 'NO_NUMBERS'
          raise NoNumbersError
        when 'BAD_SERVICE'
          raise BadServiceError
        when 'NO_ACTIVATION'
          raise NoActivationError
        when 'BAD_STATUS'
          raise BadStatusError
        else
      end
    end
  end
end
