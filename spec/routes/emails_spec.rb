require 'spec_helper'

RSpec.describe "/emails" do
  let(:user) do
    user = User.create({ first_name: "John",
                            last_name: "Doe",
                            email: "johndoe@example.com",
                            password: "password",
                            confirmation_token: "123456" })
  end

  context "/users" do
    context "/email_confirmation" do
      it "includes link with confirmation token" do
        expect do
          LiquidApi.sendmail("/emails/users/email_confirmation", user.id)
        end.to change{ Mail::TestMailer.deliveries.length }.by(1)
        confirmation_token_url = "https://localhost:3000/users/confirm_email?confirmation_token=#{user.confirmation_token}"

        expect(Mail::TestMailer.deliveries.last.to).to include user.email
        expect(Mail::TestMailer.deliveries.last.body).to include confirmation_token_url
      end
    end
  end
end
