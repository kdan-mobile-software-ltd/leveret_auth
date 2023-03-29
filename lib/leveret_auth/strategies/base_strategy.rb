module LeveretAuth
  module Strategies
    class BaseStrategy
      class << self
        def config
          @config ||= {}
        end

        def configure(configuration)
          @config = configuration
        end
      end

      def initialize(params)
        permitted_attrs.each do |key|
          instance_variable_set("@#{key}", params[key])
        end
      end

      def verify
        yield auth_info
      end

      def authenticate!
        verify do |auth_info|
          user_model.setup_user_from_third_party(auth_info[:info][:email], &before_user_save)
        end
      end

      private

      def user_model
        LeveretAuth.configuration.user_model
      end

      def before_user_save
        LeveretAuth.configuration.before_user_save
      end

      def permitted_attrs
        raise 'Must implement method: `permitted_attrs`'
      end

      def auth_info(entity)
        {
          provider: 'devise',
          uid: 'entity.uid',
          info: {
            email: 'entity.email'
          },
          extra_info: {}
        }
      end
    end
  end
end
