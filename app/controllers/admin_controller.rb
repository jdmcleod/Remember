class AdminController < ApplicationController
  before_action :ensure_admin!

  def index
    @users = User.includes(:entries, :badges, :events)
    @entries_per_day = Entry
      .where
      .not('tsv = ?', '')
      .group("DATE(created_at)")
      .count
      .to_a
      .sort_by { _1 }
      .reverse
      .take(10)
  end

  private

  def ensure_admin!
    redirect_to(root_url, alert: 'You cannot go there dumbo') unless current_user.admin?
  end
end
