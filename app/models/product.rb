class Product < ActiveRecord::Base
  monetize :price_cents
  validates :name, :description, presence: true
  validates :name, uniqueness: true

  default_scope { order('created_at DESC')}
end
