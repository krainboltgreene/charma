class User < ActiveRecord::Base
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100#" }, default_url: "default.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
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

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: [:create, :update] }
  validates_uniqueness_of :handle, :email, case_sensitive: false, :message =>
  "THAT USERNAME AND/OR EMAIL HAS ALREADY BEEN TAKEN"
  validates :handle, :name, :email, presence: {message: "FIELD CANNOT BE EMPTY"}
  validates :handle, :name, length: {in: 1...22, :message =>
  "MAX OF 22 CHARACTERS"}
  validates :handle, format: { with: /\A[a-zA-Z0-9]+\Z/,
    :message => "ONLY LETTERS/NUMBERS ALLOWED IN USERNAME"  }

  # before a user is created, set the handle/email to downcase for login purposes

  before_create do self.handle.downcase! end
  before_create do self.email.downcase! end

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

    def send_password_reset
      UserMailer.password_reset(self).deliver
    end

end
