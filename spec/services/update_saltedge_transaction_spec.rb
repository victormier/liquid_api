require 'spec_helper'

RSpec.describe Services::UpdateSaltedgeTransaction do
  let(:saltedge_transaction) { create(:saltedge_transaction) }
  let(:saltedge_trasactions_list_response) {
    f = File.read('spec/support/fixtures/saltedge_transactions_list_response.json')
    account_data = JSON.parse(f)
    account_data["data"][0]["id"] = saltedge_transaction.saltedge_id.to_i
    account_data["data"][0]["category"] = "test_category"
    account_data.to_json
  }

  before do
    # Stub saltedge account listing
    stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      to_return(
        body: saltedge_trasactions_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "updates the data about a saltedge transaction" do
    service = Services::UpdateSaltedgeTransaction.new(saltedge_transaction)
    service.call
    expect(saltedge_transaction.saltedge_data).to eq JSON.parse(saltedge_trasactions_list_response)["data"][0]
  end
end
