module DeviseAuth
  module Strategies
    class DeviseStrategy < BaseStrategy
      def authenticate!
        user = user_model.find_by(email: @email)
        raise ActiveRecord::RecordNotFound if user.nil?
        raise Errors::InvalidCredential unless user.valid_for_authentication? { user.valid_password?(@password) }

        user
      end

      def user_model
        model = super
        return model unless model.respond_to?(:devise_auth_find_user_scope)
        return model if model.devise_auth_find_user_scope.nil?

        model.devise_auth_find_user_scope
      end

      private

      def permitted_attrs
        %i[email password]
      end
    end
  end
end
