# frozen_string_literal: true

FactoryBot.define do
  # do not name this factory :user, otherwise it will conflict with factories
  # from applications that use doorkeeper factories in their own tests
  factory :mock_user, class: :user, aliases: [:resource_owner]
end
