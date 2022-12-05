# frozen_string_literal: true

module DeviseAuth
  module Ldap
    class Configuration
      class ConfigurationError < StandardError; end
      include Utils

      # For build Net::LDAP::Connection
      REQUIRED_CONNECTION_CONFIG_KEYS = %i[host port base].freeze
      OPTIONAL_CONNECTION_CONFIG_KEYS = [
        encryption: %i[method tls_opitons],
        auth: %i[method username password]
      ].freeze

      # For custom search condition
      REQUIRED_SEARCH_CONFIG_KEYS = [%i[uid filter]].freeze

      attr_reader :uid, :filter

      def initialize(configuration = {})
        validate_required_keys(configuration)

        permitted_keys = [permitted_connection_keys + permitted_search_keys].flatten
        deep_slice(configuration, permitted_keys).each do |k, v|
          instance_variable_set("@#{k}", v)
        end

        validate_encryption
        validate_auth
      end

      def connection_config
        permitted_connection_keys.each_with_object({}) do |key, hash|
          if key.is_a?(Hash)
            key.each_key { |sub_key| hash[sub_key] = instance_variable_get("@#{sub_key}") }
          else
            hash[key] = instance_variable_get("@#{key}")
          end
          hash
        end.compact
      end

      private

      def validate_required_keys(configuration)
        required_keys = REQUIRED_CONNECTION_CONFIG_KEYS + REQUIRED_SEARCH_CONFIG_KEYS
        missing_keys = validate(configuration, required_keys)

        raise ConfigurationError, build_error_message(missing_keys) unless missing_keys.empty?
      end

      def validate_encryption
        return if @encryption.nil?

        @encryption[:method] = @encryption[:method].to_sym
        return if %i[simple_tls start_tls].include?(@encryption[:method])

        tls_options = @encryption[:tls_options]
        return if tls_options.nil?

        @encryption[:tls_options] = ::OpenSSL::SSL::SSLContext::DEFAULT_PARAMS.merge(tls_options)

        raise ConfigurationError, "unsupported encryption method #{@encryption[:method]}"
      end

      def validate_auth
        return if @auth.nil?

        @auth[:method] = @auth[:method].to_sym
        if %i[simple anonymous].exclude?(@auth[:method])
          raise ConfigurationError, "unsupported auth method #{@auth[:method]}"
        end

        if @auth[:method] == :simple
          return if @auth[:username] && @auth[:password]

          raise ConfigurationError, 'simple auth must have username and password'
        end
      end

      def permitted_connection_keys
        REQUIRED_CONNECTION_CONFIG_KEYS + OPTIONAL_CONNECTION_CONFIG_KEYS
      end

      def permitted_search_keys
        REQUIRED_SEARCH_CONFIG_KEYS
      end
    end
  end
end
