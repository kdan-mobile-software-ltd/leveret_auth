require 'leveret_auth/strategies/base_strategy'

module LeveretAuth
  module Strategies
    class DeviseStrategy < BaseStrategy
      def authenticate!
        user = user_model.find_for_authentication(email: @email)
        raise Errors::InvalidCredential if user.nil?
        raise Errors::InvalidCredential unless user.valid_for_authentication? { user.valid_password?(@password) }

        user
      end

      private

      def permitted_attrs
        %i[email password]
      end
    end
  end
end
