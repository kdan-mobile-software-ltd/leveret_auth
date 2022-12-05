module DeviseAuth
  module Strategies
    class LocalStrategy < BaseStrategy
      def authenticate!
        owner_model = DeviseAuth.configuration.owner_model
        member = owner_model.registered.find_by(email: @email)
        return if member.nil?
        return unless member.valid_for_authentication? { member.valid_password?(@password) }

        member
      end

      private

      def permitted_attrs
        %i[email password]
      end
    end
  end
end
