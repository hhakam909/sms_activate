module SmsActivate
  class BaseError < RuntimeError
  end

  class ServerError < BaseError
    def initialize(msg = 'Server error') super(msg); end
  end

  class SQLError < BaseError
    def initialize(msg = 'SQL server error') super(msg); end
  end

  class NoBalanceError < BaseError
    def initialize(msg = 'Not enough balance') super(msg); end
  end

  class NoNumbersError < BaseError
    def initialize(msg = 'No numbers available') super(msg); end
  end

  class NoActivationError < BaseError
    def initialize(msg = 'Bad activation ID provided') super(msg); end
  end

  class BadStatusError < BaseError
    def initialize(msg = 'Bad status provided') super(msg); end
  end

  class BadServiceError < BaseError
    def initialize(msg = 'Bad service provided') super(msg); end
  end

  class BadKeyError < BaseError
    def initialize(msg = 'Bad API key provided') super(msg); end
  end

  class BadActionError < BaseError
    def initialize(msg = 'Bad action provided') super(msg); end
  end

  class NoKeyError < BaseError
    def initialize(msg = 'No API key provided') super(msg); end
  end

  class NoActionError < BaseError
    def initialize(msg = 'No action provided') super(msg); end
  end
end