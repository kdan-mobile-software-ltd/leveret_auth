require 'spec_helper'

RSpec.describe LeveretAuth::Config do
  subject(:config) { LeveretAuth.configuration }

  describe 'devise_for' do
    it 'bind the devise model' do
      LeveretAuth.configure do
        devise_for :users
      end

      expect(config.user_model).to eq(User)
    end

    it 'prints warning message by default' do
      block = proc {}
      LeveretAuth.configure do
        before_user_save(&block)
      end

      expect(config.before_user_save).to eq(block)
    end
  end
end
