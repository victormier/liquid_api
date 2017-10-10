module Services
  class CreateVirtualAccount
    def initialize(user, params = {})
      @user = user
      @params = params
      @form = VirtualAccountForm.new(@user.virtual_accounts.new)
    end

    def call
      saltedge_account = @user.saltedge_accounts.first

      unless saltedge_account
        raise LiquidApi::MutationInvalid.new(nil, {errors:{"saltedge_account" => "doesn't exist"}})
      end

      @params = @params.merge({
        currency_code: saltedge_account.currency_code
      }) unless @params[:currency_code]

      @form.validate(@params)

      if @form.valid?
        @form.save
      else
        errors = LiquidApiUtils::Errors::ErrorObject.new(@form.errors)
        raise LiquidApi::MutationInvalid.new(nil, errors: errors)
      end
    end

    attr_accessor :form

    def model
      form.model
    end
  end
end
