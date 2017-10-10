class RuleForm < BaseForm
  property :virtual_account_id

  validation do
    configure do
      option :form
      config.messages_file = "config/validation_error_messages.yml"

      def is_record?(klass, value)
        klass.where(id: value).any?
      end
    end

    required(:virtual_account_id).filled(is_record?: VirtualAccount)
  end
end
