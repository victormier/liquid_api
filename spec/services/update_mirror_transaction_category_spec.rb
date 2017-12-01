require 'spec_helper'

RSpec.describe Services::UpdateMirrorTransactionCategory do
  let(:mirror_transaction) { create(:mirror_transaction) }
  let(:subject) {Services::UpdateMirrorTransactionCategory.new(mirror_transaction, "test_category") }
  let(:saltedge_transactions_list_response) { File.read('spec/support/fixtures/saltedge_transactions_list_response.json') }

  before do
    stub_request(:post, "https://www.saltedge.com/api/v3/categories/learn").to_return(
      body: { "data": { "learned": true }}.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:get, "https://www.saltedge.com/api/v3/transactions").
      to_return(
        body: saltedge_transactions_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "updates the custom cateogry of a mirror transaction" do
    subject.call
    expect(mirror_transaction.reload.custom_category).to eq "test_category"
  end

  it "calls saltedge to 'learn' the new category" do
    expect(subject.call).to have_requested(:post, "https://www.saltedge.com/api/v3/categories/learn")
  end
end
