class User < ActiveRecord::Base
  has_secure_password
  acts_as_voter
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:  :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:  :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates_uniqueness_of :handle, :email, case_sensitive: false, :message =>
  "THAT USERNAME AND/OR EMAIL HAS ALREADY BEEN TAKEN"
  validates :handle, :name, :email, presence: true
  validates :handle, :name, length: {in: 1...22, :message =>
  "OOPS, LOOKS LIKE YOU ENTERED TOO LONG OF A USERNAME OR NAME"}
  validates :handle, format: { with: /\A[a-zA-Z0-9]+\Z/,
    :message => "ONLY LETTERS/NUMBERS ALLOWED IN USERNAME"  }

    def feed
      following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
      Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).order('created_at DESC')
    end

    def follow(other_user)
      User.find(other_user.id).increment!(:charma)
      active_relationships.create(followed_id: other_user.id)
    end

    def unfollow(other_user)
      User.find(other_user.id).decrement!(:charma)
      active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
      following.include?(other_user)
    end

    def self.search(search)
      where("UPPER(name) LIKE UPPER(?)", "%#{search}%")
      where("UPPER(handle) LIKE UPPER(?)", "%#{search}%")
    end

end
