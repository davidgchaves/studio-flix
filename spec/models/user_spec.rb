require 'rails_helper'
require 'support/attributes'

describe User do
  context "with example attributes" do
    it "is valid" do
      valid_user = User.new user_attributes

      expect(valid_user.valid?).to be_truthy
    end
  end

  describe "name" do
    it "can't be blank" do
      invalid_user = User.new name: ""

      invalid_user.valid?

      expect(invalid_user.errors[:name].any?).to be_truthy
    end
  end

  describe "email" do
    it "can't be blank" do
      invalid_user = User.new email: ""

      invalid_user.valid?

      expect(invalid_user.errors[:email].any?).to be_truthy
    end

    it "has to be unique and case insensitive" do
      valid_user = User.create! user_attributes
      invalid_user = User.new email: valid_user.email

      invalid_user.valid?

      expect(invalid_user.errors[:email].any?).to be_truthy
    end

    it "accepts properly formatted emails" do
      valid_emails = ["moe.sTOO@stoogies.com", "moe.sTOO@st.o.gies.com"]
      valid_emails.each do |valid_email|
        valid_user = User.new email: valid_email

        valid_user.valid?

        expect(valid_user.errors[:email].any?).to be_falsy
      end
    end

    it "rejects improperly formatted emails" do
      invalid_emails = ["@", "moe stoo@stoogies.com", "moe.stoo@sto ogies.com"]
      invalid_emails.each do |invalid_email|
        invalid_user = User.new email: invalid_email

        invalid_user.valid?

        expect(invalid_user.errors[:email].any?).to be_truthy
      end
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
