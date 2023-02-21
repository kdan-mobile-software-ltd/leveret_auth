# frozen_string_literal: true

require 'leveret_auth/utils'
require 'leveret_auth/config'
require 'leveret_auth/engine'

# Main LeveretAuth namespace.
#
module LeveretAuth
  autoload :Errors, 'leveret_auth/errors'

  module Strategies
    autoload :LdapStrategy, 'leveret_auth/strategies/ldap_strategy'
    autoload :DeviseStrategy, 'leveret_auth/strategies/devise_strategy'
  end

  module Orm
    autoload :ActiveRecord, 'leveret_auth/orm/active_record'
  end

  module Integration
    autoload :Doorkeeper, 'leveret_auth/integration/doorkeeper'
  end

  class << self
    def find_strategy(strategy_name)
      raise Errors::StrategyNotFound unless allowed_provider?(strategy_name)

      strategy = "LeveretAuth::Strategies::#{strategy_name.to_s.camelize}Strategy".safe_constantize
      strategy || (raise Errors::StrategyNotFound)
    end

    private

    def allowed_provider?(provider)
      return false if provider.nil?

      configuration.providers.include?(provider.downcase.to_sym)
    end
  end
end
