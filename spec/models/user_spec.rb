require 'rails_helper'

describe User do
  describe "name" do
    it "can't be blank" do
      invalid_user = User.new name: ""

      invalid_user.valid?

      expect(invalid_user.errors[:name].any?).to be_truthy
    end
  end

  describe "password" do
    it "can't be blank" do
      invalid_user = User.new password: ""

      invalid_user.valid?

      expect(invalid_user.errors[:password].any?).to be_truthy
    end

    context "when present" do
      it "has to match the password confirmation" do
        invalid_user = User.new password: "secret", password_confirmation: "nomatch"

        invalid_user.valid?

        expect(invalid_user.errors[:password_confirmation].any?).to be_truthy
      end

      it "is automatically encrypted into the password_digest attribute" do
         user = User.new password: "secret"

         expect(user.password_digest.present?).to be_truthy
      end
    end
  end
end
