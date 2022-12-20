# frozen_string_literal: true

require 'devise_auth/utils'
require 'devise_auth/config'
require 'devise_auth/engine'

# Main DeviseAuth namespace.
#
module DeviseAuth
  autoload :Errors, 'devise_auth/errors'

  module Strategies
    autoload :LdapStrategy, 'devise_auth/strategies/ldap_strategy'
    autoload :DeviseStrategy, 'devise_auth/strategies/devise_strategy'
  end

  module Orm
    autoload :ActiveRecord, 'devise_auth/orm/active_record'
  end

  class << self
    def auth_with_doorkeeper(params)
      strategy_class = find_strategy(params[:grant_type], provider: params[:provider])
      strategy = strategy_class.new(params)
      strategy.authenticate!
    end

    private

    def find_strategy(grant_type, provider: nil)
      dispathcer_name = "#{grant_type.to_s.downcase}_strategy"
      raise Errors::StrategyNotFound unless respond_to?(dispathcer_name, true)

      method(dispathcer_name).call(provider)
    end

    def password_strategy(provider)
      return Strategies::DeviseStrategy if provider.nil?
      raise Errors::StrategyNotFound unless allowed_provider?(provider)

      const_get("Strategies::#{provider.to_s.camelize}Strategy")
    end

    def allowed_provider?(provider)
      return false if provider.nil?

      configuration.providers.include?(provider.downcase.to_sym)
    end
  end
end
