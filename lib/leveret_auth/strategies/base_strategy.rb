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

      def authenticate!
        raise 'Must implement the method: `authenticate!`'
      end

      private

      def user_model
        LeveretAuth.configuration.user_model
      end

      def permitted_attrs
        raise 'Must implement method: `permitted_attrs`'
      end
    end
  end
end
