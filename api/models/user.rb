class User < ActiveRecord::Base
  has_secure_password

  has_many :saltedge_logins
  has_many :saltedge_accounts
  has_many :virtual_accounts
  has_many :rules

  CONNECTION_PHASES = {
    new_login: "new_login",
    login_failed: "login_failed",
    login_pending: "login_pending",
    select_account: "select_account",
    connected: "connected",
    needs_reconnection: "needs_reconnection"
  }

  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.now.utc
  end

  def reset_password_token_valid?
    (reset_password_token_generated_at + 1.day) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save!
  end

  def confirmed?
    !killed? && !confirmed_at.nil?
  end

  def is_saltedge_customer?
    !saltedge_id.nil?
  end

  def default_saltedge_account
    saltedge_accounts.first
  end

  def default_mirror_account
    virtual_accounts.mirror.first
  end

  def killed?
    will_be_removed_at.present?
  end

  def default_saltedge_login
    saltedge_logins.last
  end

  def bank_connection_phase
    if default_saltedge_login
      if default_saltedge_login.needs_reconnection
        User::CONNECTION_PHASES[:needs_reconnection]
      elsif default_mirror_account
        User::CONNECTION_PHASES[:connected]
      elsif default_saltedge_login.active
        User::CONNECTION_PHASES[:select_account]
      elsif !default_saltedge_login.finished_connecting
        User::CONNECTION_PHASES[:login_pending]
      elsif default_saltedge_login.new_login_and_invalid?
        User::CONNECTION_PHASES[:login_failed]
      end
    else
      User::CONNECTION_PHASES[:new_login]
    end
  end

  def total_balance
    virtual_accounts.sum(:balance)
  end

  def currency_code
    default_mirror_account.try(:currency_code)
  end
end
