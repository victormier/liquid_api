class BaseForm < Reform::Form
  def full_error_messages
    return [] unless errors.present?
    errors.as_json["errors"].map do |attribute, errors|
      errors.map { |error| "#{attribute.capitalize} #{error}" }
    end.flatten
  end
end
