require 'spec_helper'

RSpec.describe VirtualTransaction, type: :model do
  subject {
    build(:virtual_transaction)
  }
  let(:virtual_transaction) {
    expect(subject.save).to be true
    subject
  }

  it "allows creation of a virtual transaction" do
    expect(subject.save).to be true
  end
end
