require 'rails_helper'

describe User do
  describe "password" do
    it "can't be blank" do
      invalid_user = User.new password: ""

      invalid_user.valid?

      expect(invalid_user.errors[:password].any?).to be_truthy
    end
  end
end
