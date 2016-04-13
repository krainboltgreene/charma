class Post < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  validates :post_text, presence: true

  def self.search(search)
    where("UPPER(post_text) LIKE UPPER(?)", "%#{search}%")
  end

end
