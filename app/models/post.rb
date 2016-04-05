class Post < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  validates :post_text, presence: true

end
