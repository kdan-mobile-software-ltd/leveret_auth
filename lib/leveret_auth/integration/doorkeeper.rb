# frozen_string_literal: true

module LeveretAuth
  module Integration
    class Doorkeeper
      class GrantTypeError end

      class << self
        def authenticate!(params)
          strategy_class = find_strategy(params[:grant_type], provider: params[:provider])
          strategy = strategy_class.new(params)
          strategy.authenticate!
        end

        private

        def find_strategy(grant_type, provider: nil)
          dispathcer_name = "#{grant_type.to_s.downcase}_strategy"
          raise GrantTypeError unless respond_to?(dispathcer_name, true)
          
          method(dispathcer_name).call(provider)
        end

        def password_strategy(provider)
          LeveretAuth.find_strategy(provider || :devise)
        end
      end
    end
  end
end
