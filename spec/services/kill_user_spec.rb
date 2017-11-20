require 'spec_helper'

RSpec.describe Services::KillUser do
  let(:user) { create(:user) }
  let(:subject) { Services::KillUser.new(user) }

  it "creates a RemoveUserWorker job" do
    Sidekiq::Testing.fake! do
      expect { subject.call }.to change{ RemoveUserWorker.jobs.size }.by(1)
      expect(RemoveUserWorker.jobs.first["at"].to_i).to eq(user.reload.will_be_removed_at.to_i)
    end
  end

  it "updates user's will be removed at" do
    Sidekiq::Testing.fake! do
      Timecop.freeze do
        remove_user_at = Services::KillUser::DAYS_TO_KEEP_DATA.days.from_now
        expect {subject.call }.to change {user.reload.will_be_removed_at.try(:to_i) }.from(nil).to(remove_user_at.to_i)
      end
    end
  end
end
