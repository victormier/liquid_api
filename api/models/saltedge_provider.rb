class SaltedgeProvider < ActiveRecord::Base
  serialize :saltedge_data, Hash

  scope :automatically_fetchable, -> { where(automatic_fetch: true) }
  scope :not_fake, -> { where("country_code != 'XF'") }

  def self.selectable
    if ENV['LIQUID_ENV'] == 'production'
      automatically_fetchable.not_fake
    else
      all
    end
  end

  def instruction
    saltedge_data["instruction"]
  end
end
