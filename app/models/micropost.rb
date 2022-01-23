class Micropost < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 255 }
  
  # お気にり機能の多対多の関係記述
  has_many :favorites
  has_many :favorited, through: :favorites, source: :user
end