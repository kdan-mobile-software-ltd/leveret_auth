# frozen_string_literal: true

require 'devise_auth/config'
require 'devise_auth/engine'

# Main DeviseAuth namespace.
#
module DeviseAuth
  autoload :Utils, 'devise_auth/utils'
  module Strategies
    autoload :BaseStrategy, 'devise_auth/strategies/base_strategy'
    autoload :LdapStrategy, 'devise_auth/strategies/ldap_strategy'
    autoload :LocalStrategy, 'devise_auth/strategies/local_strategy'
  end

  module Orm
    autoload :ActiveRecord, 'devise_auth/orm/active_record'
  end

  module Ldap
    autoload :Configuration, 'devise_auth/ldap/configuration'
    autoload :Connection, 'devise_auth/ldap/connection'
  end

  module Errors
    class StrategyNotFound < StandardError; end
    class ThirdPartyNotProvideEmail < StandardError; end
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
      return Strategies::LocalStrategy if provider.nil?
      raise Errors::StrategyNotFound unless allowed_provider?(provider)

      const_get("Strategies::#{provider.to_s.camelize}Strategy")
    end

    def oauth_strategy(provider)
      raise Errors::StrategyNotFound unless allowed_provider?(provider)

      const_get("Strategies::OAuth::#{provider.to_s.camelize}Strategy")
    end

    def allowed_provider?(provider)
      return false if provider.nil?

      configuration.providers.include?(provider.downcase.to_sym)
    end
  end
end