module DeviseAuth
  module Strategies
    class LocalStrategy < BaseStrategy
      def authenticate!
        member = owner_model.find_by(email: @email)
        return if member.nil?
        return unless member.valid_for_authentication? { member.valid_password?(@password) }

        member
      end

      def owner_model
        model = super
        return model unless model.respond_to?(:devise_auth_find_member_scope)
        return model if model.devise_auth_find_member_scope.nil?

        model.devise_auth_find_member_scope
      end

      private

      def permitted_attrs
        %i[email password]
      end
    end
  end
end
