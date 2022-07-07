class Palette < ApplicationRecord
  has_and_belongs_to_many :colors
  has_and_belongs_to_many :tags

  validates :name, presence: true
end
