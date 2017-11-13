require 'spec_helper'

RSpec.describe Services::RemoveSaltedgeLogin do
  let(:saltedge_login) { create(:saltedge_login)}
  let(:subject) { Services::RemoveSaltedgeLogin.new(saltedge_login)}
  before do
    # Stub saltedge customer creation
    stub_request(:delete, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}").
     to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "destroys the login on saltedge" do
    expect(subject.call).to have_requested(:delete, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}")
  end

  it "it 'kills' the saltedge login" do
    Sidekiq::Testing.fake! do
      expect { subject.call }.to change{ saltedge_login.reload.killed }.from(false).to(true)
    end
  end

  describe "when delete fails" do
    before do
      stub_request(:delete, "https://www.saltedge.com/api/v3/logins/#{saltedge_login.saltedge_id}").
       to_return(
          status: 500,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it "doesn't kill the saltedge login" do
      expect {
        begin
          subject.call
        rescue RestClient::InternalServerError
          nil
        end }.to_not change{ saltedge_login.reload.killed }
    end
  end
end
