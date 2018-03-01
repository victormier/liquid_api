class SaltedgeLogin < ActiveRecord::Base
  belongs_to :user
  belongs_to :saltedge_provider
  has_many :saltedge_accounts

  serialize :saltedge_data, Hash
  serialize :interactive_data, Hash

  delegate :interactive, to: :saltedge_provider

  def active
    saltedge_data["status"] == "active" && !saltedge_data["last_success_at"].blank?
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
    (inactive && saltedge_data["last_success_at"].present? && error.present?) ||
    (saltedge_data["last_success_at"].blank? && interactive_session_expired?)
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

  def next_refresh_possible_at
    return unless saltedge_data["next_refresh_possible_at"]
    DateTime.iso8601(saltedge_data["next_refresh_possible_at"]).utc
  end

  def last_success_at
    return unless saltedge_data["last_success_at"]
    DateTime.iso8601(saltedge_data["last_success_at"]).utc
  end

  def can_be_refreshed?
    if next_refresh_possible_at
      next_refresh_possible_at <= DateTime.now
    elsif last_success_at
      last_success_at <= 60.minutes.ago
    else
      true
    end
  end

  def has_unfinished_attempt
    saltedge_data["last_attempt"].try(:[], "finished") != true
  end

  def is_refreshing
    has_unfinished_attempt
  end

  def provider_name
    saltedge_data["provider_name"]
  end

  def waiting_interactive_connection?
    interactive_session_active? && saltedge_data["last_attempt"].try(:[], "last_stage").try(:[], "name") == "connect"
  end

  def interactive_session_active?
    return false unless interactive_data["session_expires_at"]
    DateTime.iso8601(interactive_data["session_expires_at"]).utc > DateTime.now
  end

  def interactive_session_expired?
    return false unless interactive_data["session_expires_at"]
    !interactive_session_active?
  end
end
