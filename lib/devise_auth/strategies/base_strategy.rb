module DeviseAuth
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
        raise 'Must implement Method: `autnenciate!`'
      end

      private

      def user_model
        DeviseAuth.configuration.user_model
      end

      def permitted_attrs
        raise 'Must implement Method: `permitted_attr`'
      end
    end
  end
end
