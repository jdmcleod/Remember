class AdminController < ApplicationController
  before_action :ensure_admin!

  def index
    @users = User.left_joins(:entries).includes(:badges, :events).order('COUNT(entries.id) DESC').group('users.id')

    @entries_per_day = Entry
      .where
      .not('tsv = ?', '')
      .group("DATE(created_at)")
      .count
      .to_a
      .sort_by { _1 }
      .reverse
      .take(30)
  end

  def sync_be_real
    BeRealApi::V1::Importer.import
  end

  private

  def ensure_admin!
    redirect_to(root_url, alert: 'You cannot go there dumbo') unless current_user.admin?
  end
end
