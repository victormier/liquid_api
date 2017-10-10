module Services
  class UpdatePercentageRule
    def initialize(user, params)
      @user = user
      @params = params
      @form = nil
    end

    def call
      PercentageRule.transaction do
        percentage_rule = PercentageRule.where(user_id: @user.id).find(@params[:percentage_rule_id])
        @form = PercentageRuleForm.new(percentage_rule)

        @form.validate(@params)

        if @form.valid?
          @form.save
        else
          errors = LiquidApiUtils::Errors::ErrorObject.new(@form.errors)
          raise LiquidApi::MutationInvalid.new(nil, errors: errors)
        end
      end
    end

    def model
      @form.try(:model)
    end
  end
end
