require 'spec_helper'

RSpec.describe SaltedgeLogin, type: :model do
  subject { build(:saltedge_login) }
  let(:saltedge_login) {
    expect(subject.save).to be true
    subject
  }

  it "allows creation of a saltedge_login" do
    expect(subject.save).to be true
  end

  describe "#kill" do
    it "updates killed to true" do
      Sidekiq::Testing.fake! do
        expect { saltedge_login.kill }.to change{ saltedge_login.killed }.from(false).to(true)
      end
    end

    it "creates a DestroySaltedgeLoginWorker job to be performed in a day" do
      Sidekiq::Testing.fake! do
        expect { saltedge_login.kill }.to change{ DestroySaltedgeLoginWorker.jobs.size }.by(1)
      end
    end
  end
end
