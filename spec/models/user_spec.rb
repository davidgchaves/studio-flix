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
    it "is secure" do
      expect(subject).to have_secure_password
    end

    it "contains at least 10 characters" do
      expect(subject).to validate_length_of(:password).is_at_least(10)
    end
  end
end
