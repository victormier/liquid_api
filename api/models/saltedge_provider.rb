class SaltedgeProvider < ActiveRecord::Base
  serialize :saltedge_data, Hash

  scope :automatically_fetchable, -> { where(automatic_fetch: true) }
  scope :interactive, -> { where(interactive: true) }
  scope :not_fake, -> { where("country_code != 'XF'") }

  def self.selectable
    if ENV['LIQUID_ENV'] == 'production'
      self.where("automatic_fetch = TRUE OR interactive = TRUE").not_fake
    else
      all
    end
  end

  def instruction
    saltedge_data["instruction"]
  end

  def interactive_fields
    saltedge_data['interactive_fields']
  end
end
