require 'rails_helper'
require 'support/attributes'

describe User do
  let(:user) { User.new user_attributes }

  context "with example attributes" do
    it "is valid" do
      expect(user.valid?).to be_truthy
    end
  end

  describe "name" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :name
    end
  end

  describe "email" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :email
    end

    it "has to be (case insensitive) unique" do
      expect(subject).to validate_uniqueness_of(:email).case_insensitive
    end

    context "when properly formatted" do
      let(:valid_emails) { ["moe.sTOO@stoogies.com", "moe.sTOO@st.o.gies.com"] }

      it "is valid" do
        valid_emails.each do |valid_email|
          expect(subject).to allow_value(valid_email).for :email
        end
      end
    end

    context "when improperly formatted" do
      let(:invalid_emails) { ["@", "moe stoo@stoogies.com", "moe.stoo@sto ogies.com"] }

      it "is invalid" do
        invalid_emails.each do |invalid_email|
          expect(subject).not_to allow_value(invalid_email).for :email
        end
      end
    end
  end

  describe "password" do
    it "can't be blank" do
      invalid_user = User.new password: ""

      invalid_user.valid?

      expect(invalid_user.errors[:password].any?).to be_truthy
    end

    it "contains at least 10 characters" do
      invalid_user = User.new password: "X" * 9

      invalid_user.valid?

      expect(invalid_user.errors[:password].any?).to be_truthy
    end

    context "when present" do
      it "has to match the password confirmation" do
        invalid_user = User.new password: "secret-santa", password_confirmation: "nomatch"

        invalid_user.valid?

        expect(invalid_user.errors[:password_confirmation].any?).to be_truthy
      end

      it "is automatically encrypted into the password_digest attribute" do
         user = User.new password: "secret-santa"

         expect(user.password_digest.present?).to be_truthy
      end
    end
  end
end
