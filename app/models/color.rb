class Color < ApplicationRecord
  has_and_belongs_to_many :palettes
  has_and_belongs_to_many :tags

  validates :hex,
    :presence => true,
    :uniqueness => true,
    :format => { :with => /\A#[0-9a-fA-F]{6}\z/i }
end
