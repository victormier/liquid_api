class LoginForm < Reform::Form
  property :email
  property :password

  def initialize
    super(OpenStruct.new(email: nil, password: nil))
  end

  validation do
    required(:email).filled
    required(:password).filled
  end

  def email=(value)
    super(value.try(:downcase))
  end
end
