class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  # フォロー機能の多対多の関係記述
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
    # お気に入り機能の多対多の関係記述
  has_many :favorites
  has_many :favoritings, through: :favorites, source: :micropost

  # followするためのメソッド
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  # unfollowするためのメソッド
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # すでにフォロー済みかを確認するメソッド
  def following?(other_user)
    self.followings.include?(other_user)
  end

  # タイムライン用の関数
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end  

  # お気に入りに追加するためのメソッド
  def favorite(micropost)
    # お気に入り機能は自分の投稿もお気に入りにして良いので下記は不要
    # unless self == other_user
    self.favorites.find_or_create_by(micropost_id: micropost.id)
    # end
  end

  # お気に入りを削除するためのメソッド
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end

  # すでにお気に入り済みかを確認するメソッド
  def favoriting?(micropost)
    self.favoritings.include?(micropost)
  end

end