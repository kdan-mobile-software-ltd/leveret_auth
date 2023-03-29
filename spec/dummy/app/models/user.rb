# frozen_string_literal: true

class User < ApplicationRecord
  def self.authenticate!(name, password)
    User.where(name: name, password: password).first
  end
end
