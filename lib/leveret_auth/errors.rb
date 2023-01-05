# frozen_string_literal: true

module LeveretAuth
  module Errors
    class StrategyNotFound < StandardError; end
    class ThirdPartyNotProvideEmail < StandardError; end
    class InvalidCredential < StandardError; end
  end
end
