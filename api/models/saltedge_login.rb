class SaltedgeLogin < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_provider
  has_many :saltedge_accounts

  serialize :saltedge_data, Hash

  def active
    saltedge_data["status"] == "active"
  end

  def inactive
    saltedge_data["status"] == "inactive"
  end

  def kill
    self.update_attributes(killed: true)
    DestroySaltedgeLoginWorker.perform_in(1.day, id)
  end

  def finished_connecting
    saltedge_data["status"] == "active" ||
    (saltedge_data["last_attempt"] && saltedge_data["last_attempt"]["finished"])
  end

  def needs_reconnection
    inactive && saltedge_data["last_success_at"].present? && error.present?
  end

  def error
    saltedge_data["last_attempt"].try(:[], "fail_error_class")
  end

  def error_message
    saltedge_data["last_attempt"].try(:[], "fail_message")
  end

  def new_login_and_invalid?
    finished_connecting && error && saltedge_accounts.none?
  end
end
