module ApplicationHelper
  def leaderboard
    Post.order("created_at DESC").limit(5)
  end
end
