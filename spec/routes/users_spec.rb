require 'spec_helper'

RSpec.describe "/users" do
  let(:user) do
    service = Services::RegisterUser.new({ first_name: "John",
                     last_name: "Doe",
                     email: "johndoe@example.com",
                     password: "password",
                     password_confirmation: "password" })
    expect(service.call).to be true
    expect(service.model.persisted?).to be true
    service.model
  end

  context "/create" do
    let(:params) { { email: "markdoe@example.com", password: "password", password_confirmation: "password" } }

    it "registers a user with valid data" do
      expect {
        post "/users", params.to_json
      }.to change{ User.count }.by(1)
      expect(last_response.ok?).to be true
    end

    it "returns errors if form validation fails" do
      params[:email] = "wrongemailformat"
      expect {
        post "/users", params.to_json
      }.to change{ User.count }.by(0)

      expect(json_response.keys).to include("errors")
      expect(json_response["errors"]).to eq(["Email is in invalid format"])
      expect(last_response.status).to eq Rack::Utils.status_code(:unprocessable_entity)
    end
  end

  context "/confirm_email" do
    it "confirms user email" do
      get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"
      expect(user.reload.confirmed?).to be true
    end

    it "sets a reset_password token" do
      expect(user.reset_password_token).to be nil
      get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"

      expect(user.reload.reset_password_token).to_not be nil
    end

    it "redirects the user to a reset password page" do
      get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"
      expect(last_response.status).to eq Rack::Utils.status_code(:found)
      expect(last_response.headers["Location"]).to eq "https://#{LiquidApi.configuration.default_client_host}/users/reset_password?reset_password_token=#{user.reload.reset_password_token}"
    end

    context "when token has expired" do
      before do
        user.update_attributes(confirmation_sent_at: Time.now - (31*60*60*24))
      end

      it "doesn't confirm user" do
        get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"

        expect(last_response.ok?).to be true
        expect(user.reload.confirmed?).to be false
      end

      it "resubmits email" do
        expect do
          get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"
        end.to change{ Mail::TestMailer.deliveries.length }.by(1)
        expect(Mail::TestMailer.deliveries.last.subject).to eq "Liquid email confirmation"
        expect(Mail::TestMailer.deliveries.last.to).to include user.email
      end

      it "renders email submitted message" do
        get "/users/confirm_email?confirmation_token=#{user.confirmation_token}"
        expect(last_response.ok?).to be true
        expect(last_response.body).to include "We've sent you a new confirmation email."
      end
    end

    it "renders 'we couldn't find anything' message if token doesn't exist" do
      get "/users/confirm_email?confirmation_token=loremipsum"
      expect(last_response.ok?).to be true
      expect(last_response.body).to include "We couldn't find any user to confirm with that link"
    end
  end

  context "/request_reset_password" do
    it "sets a reset_password_token" do
      expect(user.reset_password_token).to be nil
      post "/users/request_reset_password", { email: user.email }.to_json
      expect(user.reload.reset_password_token).to_not be nil
      expect(last_response.ok?).to be true
    end

    it "submits a reset password email" do
      user # create user (triggers an email which we don't want to test)
      expect do
        post "/users/request_reset_password", { email: user.email }.to_json
      end.to change{ Mail::TestMailer.deliveries.length }.by(1)
      expect(Mail::TestMailer.deliveries.last.subject).to eq "Liquid reset password"
      expect(Mail::TestMailer.deliveries.last.to).to include user.email
    end

    it "returns ok even if email doesn't exist" do
      expect do
        post "/users/request_reset_password", { email: "nonexisting@email.com" }.to_json
      end.to change{ Mail::TestMailer.deliveries.length }.by(0)
      expect(last_response.ok?).to be true
    end
  end

  context "/:id/set_password" do
    let(:params) { { password: "123456", password_confirmation: "123456" } }
    before { user.mark_as_confirmed! }

    it "sets a new password for a user" do
      post "/users/#{user.id}/set_password", params.to_json

      expect(last_response.ok?).to be true
      expect(json_response.keys).to include "auth_token"
      expect(json_response.keys).to include "user_id"
    end

    it "returns an error if user email is not confirmed" do
      allow_any_instance_of(User).to receive(:confirmed?).and_return(false)
      post "/users/#{user.id}/set_password", params.to_json

      expect(last_response.ok?).to be false
      expect(last_response.status).to eq Rack::Utils.status_code(:unprocessable_entity)
      expect(json_response["errors"]).to include "Email is not confirmed"
    end

    it "returns errors if form validation fails" do
      params[:password_confirmation] = "wrongpassword"
      post "/users/#{user.id}/set_password", params.to_json

      expect(last_response.ok?).to be false
      expect(last_response.status).to eq Rack::Utils.status_code(:unprocessable_entity)
      expect(json_response["errors"]).to include "Password confirmation doesn't match password"
    end

    it "raises ActiveRecord::RecordNotFound if user doesn't exist" do
      expect {
        post "/users/999999999/set_password", params.to_json
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context "/from_reset_password_token" do
    it "returns user info from reset password token" do
      Services::ResetUserPassword.new(user).call
      get "/users/from_reset_password_token", { reset_password_token: user.reset_password_token }

      expect(last_response.ok?).to be true
      expect(json_response.keys).to include("user")
      expect(json_response["user"]).to include("email" => user.email, "id" => user.id)
    end

    it "raises an exception if reset password not valid" do
      expect {
        get "/users/from_reset_password_token", { reset_password_token: "123456789" }
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
