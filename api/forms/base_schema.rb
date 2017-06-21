class BaseSchema < Dry::Validation::Schema
  configure do |config|
    config.messages_file = "config/validation_error_messages.yml"
    config.messages = :i18n
  end

  def unique?(attr, value)
    form.model.class.where.not(id: form.model.id).find_by(attr => value).nil?
  end
end
