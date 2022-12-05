# frozen_string_literal: true

module DeviseAuth
  class MissingConfiguration < StandardError
    def initialize
      super("Configuration for on-premise auth missing. Do you have on-premise auth initializer?")
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
      DeviseAuth::Orm::ActiveRecord.run_hooks
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

    def owner_name
      @owner_name.to_s.classify
    end

    def owner_model
      @owner_model ||= owner_name.constantize
    end

    def identities_model
      @identities_model ||= 'DeviseAuth::Identities'.constantize
    end

    # Default DiviseAuth configuration builder
    class Builder
      def initialize(config = Config.new, &block)
        @config = config
        instance_eval(&block)
      end

      def build
        @config
      end

      def devise_for(owner_name)
        @config.instance_variable_set(:@owner_name, owner_name)
      end

      def add_provider(name, **opts)
        opts = load_provider_options_file(opts[:file_path]) if opts[:file_path]
        begin
          klass = DeviseAuth::Strategies.const_get("#{name.to_s.camelize}Strategy")
        rescue NameError
          raise LoadError, "Could not find matching strategy for #{name}."
        end
        @config.providers << name.downcase
        klass.configure(opts.compact)
      end

      def load_provider_options_file(file_path)
        file = File.open(Rails.root.join(file_path), 'r').read
        JSON.parse(file).deep_symbolize_keys
      end
    end
  end
end