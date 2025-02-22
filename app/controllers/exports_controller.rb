class ExportsController < ApplicationController
  def new
    render layout: 'modal'
  end

  def create
    entries_json = current_user
     .entries
     .with_all_rich_text
     .map(&:as_json)

    badges_json = current_user.badges.includes(day_badges: :day).map(&:as_json)
    events_json = current_user.events.map(&:as_json)

    json = {
      entries: entries_json,
      badges: badges_json,
      events: events_json
    }

    send_data JSON.pretty_generate(json),
      type: 'application/json; charset=utf-8; header=present',
      filename: 'remember_backup.json',
      disposition: 'attachment'
  end
end
