# require 'mixpanel-ruby'

class MixpanelClient
  def self.tracker
    @tracker ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end
end
