# frozen_string_literal: true

module LeveretAuth::Orm::ActiveRecord::Mixins
  module Identities
    extend ActiveSupport::Concern

    included do
      self.table_name = 'identities'
      self.strict_loading_by_default = false if respond_to?(:strict_loading_by_default)

      belongs_to :user, class_name: "::#{LeveretAuth.configuration.user_model_name}",
                        inverse_of: :identities
    end
  end
end
