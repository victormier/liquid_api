module Services
  class UpdateMirrorTransactionCategory
    def initialize(mirror_transaction, category_code)
      @mirror_transaction = mirror_transaction
      @category_code = category_code
    end

    def call
      form = MirrorTransactionForm.new(@mirror_transaction)
      if form.validate(custom_category: @category_code)
        form.save
        UpdateSaltedgeTransactionCategoryWorker.perform_async(@mirror_transaction.saltedge_transaction.id, @category_code)
      else
        errors = LiquidApiUtils::Errors::ErrorObject.new(form.errors)
        raise LiquidApi::MutationInvalid.new(errors.full_messages.join('; '), errors: errors)
      end
    end

    def model
      @mirror_transaction
    end
  end
end
