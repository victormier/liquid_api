# require 'mixpanel-ruby'

class MixpanelClient
  EVENTS = {
    view_page: 'View Page',
    view_blog: 'View blog',
    input_signup_email: 'Input signup email',
    click_signup_email: 'Click sign-up email',
    view_signup_password_page: 'View signup password page',
    setup_signup_password: 'Set-up signup password',
    search_bank: 'Search bank',
    select_bank: 'Select bank',
    connect_bank_first_step: 'Connect bank first step',
    connect_bank_interactive: 'Connect bank interactive',
    connect_bank: 'Connect bank',
    view_accounts: 'View accounts',
    view_account_transactions: 'View account transactions',
    view_transaction_details: 'View transaction details',
    view_insights: 'View insights',
    insights_switch_month: 'Insights switch month',
    view_settings: 'View settings',
    start_transfer: 'Start transfer',
    select_origin_account: 'Select origin account',
    select_destination_account: 'Select destination account',
    transfer_complete: 'Transfer complete',
    end_session: 'End session',
    logout: 'Log-out'
  }

  class << self
    def track(*params)
      self.delay({retry: 3}).simple_track(*params)
    end

    def set_people_properties(*params)
      self.delay({retry: 3}).simple_set_people_properties(*params)
    end

    private

    def simple_track(*params)
      tracker.track(*params)
    end

    def simple_set_people_properties(*params)
      tracker.people.set(*params)
    end

    def tracker
      @tracker ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
    end
  end
end
