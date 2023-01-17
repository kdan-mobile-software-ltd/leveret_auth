# frozen_string_literal: true

module LeveretAuth
  class MissingConfiguration < StandardError
    def initialize
      super('Configuration for leveret auth missing. Do you have on-premise auth initializer?')
    end
  end

  class << self
    def setup
      run_orm_hooks
      add_extension_to_devise
    end

    def configuration
      @configuration || (raise MissingConfiguration)
    end

    def configure(&block)
      @configuration = Config::Builder.new(&block).build
    end

    private

    def run_orm_hooks
      LeveretAuth::Orm::ActiveRecord.run_hooks
    end

    def add_extension_to_devise
      Devise.add_module :auth_identitable, model: 'devise/models/auth_identitable'
    end
  end

  # Default DiviseAuth configuration
  class Config
    def providers
      @providers ||= []
    end

    def user_model_name
      @user_model_name.to_s.classify
    end

    def user_model
      @user_model ||= user_model_name.constantize
    end

    def identities_model
      @identities_model ||= 'LeveretAuth::Identities'.constantize
    end

    # Default DiviseAuth configuration builder
    class Builder
      def initialize(config = Config.new, &block)
        @config = config
        instance_eval(&block)
      end

      def build
        validate
        @config
      end

      def validate; end

      def devise_for(model_name)
        @config.instance_variable_set(:@user_model_name, model_name)
      end

      def add_provider(name, **opts)
        opts = Utils.load_json_file(opts[:file_path]) if opts[:file_path]
        begin
          klass = Strategies.const_get("#{name.to_s.camelize}Strategy")
        rescue NameError
          raise LoadError, "Could not find matching strategy for #{name}."
        end
        @config.providers << name.downcase
        klass.configure(opts.compact)
      end
    end
  end
end
