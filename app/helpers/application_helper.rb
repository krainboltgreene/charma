module ApplicationHelper
  def recent
    Post.order("created_at DESC").limit(5)
  end
end
