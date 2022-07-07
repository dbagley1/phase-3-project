class Tag < ApplicationRecord
  has_and_belongs_to_many :colors
  has_and_belongs_to_many :palettes

  validates :name, presence: true, uniqueness: true
end
