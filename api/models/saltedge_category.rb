class SaltedgeCategory
  attr_reader :key

  def initialize(category_name)
    @key = category_name
  end

  def name
    key.humanize
  end

  def subcategories
    if SALTEDGE_CATEGORY_NAMES[key].respond_to?(:map)
      SALTEDGE_CATEGORY_NAMES[key].map do |saltedge_category|
        SaltedgeCategory.new(saltedge_category)
      end
    else
      []
    end
  end

  def self.all
    @all ||= SALTEDGE_CATEGORY_NAMES.keys.map do |saltedge_category|
      SaltedgeCategory.new(saltedge_category)
    end
  end
end
