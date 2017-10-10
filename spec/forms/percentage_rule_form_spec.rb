require 'spec_helper'

RSpec.describe PercentageRuleForm do
  let(:user) { create(:user, :with_mirror_account) }
  let(:params) {
    {
      percentage: 10.0,
      minimum_amount: 10.0,
      active: "yes"
    }
  }

  subject { PercentageRuleForm.new(PercentageRule.new)  }

  it "creates a new percentage rule with valid data" do
    subject.validate(params)

    expect(subject.valid?).to be true
    expect(subject.save).to be true
    expect(subject.model.persisted?).to be true
  end

  context "validations" do
    it "validates presence of minimum_amount" do
      subject.validate(params.merge({ minimum_amount: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:minimum_amount]).to include("must be filled")
    end

    it "validates presence of percentage" do
      subject.validate(params.merge({ percentage: nil }))

      expect(subject.valid?).to be false
      expect(subject.errors[:percentage]).to include("must be filled")
    end

    it "validates format of percentage" do
      subject.validate(params.merge({ percentage: "asdf" }))

      expect(subject.valid?).to be false
      expect(subject.errors[:percentage]).to include("must be a decimal")
    end

    it "validates format of minimum_amount" do
      subject.validate(params.merge({ minimum_amount: "asdf" }))

      expect(subject.valid?).to be false
      expect(subject.errors[:minimum_amount]).to include("must be a decimal")
    end

    it "fails for negative percentage values" do
      subject.validate(params.merge({ percentage: -5 }))

      expect(subject.valid?).to be false
      expect(subject.errors[:percentage]).to include("must be greater than or equal to 0")
    end

    it "fails for percentage values over 100" do
      subject.validate(params.merge({ percentage: 100.1 }))

      expect(subject.valid?).to be false
      expect(subject.errors[:percentage]).to include("must be less than or equal to 100")
    end

    it "fails for negative minimum_amount values" do
      subject.validate(params.merge({ minimum_amount: -5 }))

      expect(subject.valid?).to be false
      expect(subject.errors[:minimum_amount]).to include("must be greater than or equal to 0")
    end
  end
end
