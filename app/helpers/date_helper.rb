# frozen_string_literal: true

module DateHelper
  def format_date(date, format = :simple_date, time: true)
    return nil if date.blank?

    date = date.to_date unless time
    date.to_fs(format)
  end

  def format_range(start_date, end_date)
    if start_date.year == end_date.year
      if start_date.month == end_date.month
        "#{start_date.strftime('%b %-d')}-#{end_date.strftime('%-d, %Y')}"
      else
        "#{start_date.strftime('%b %-d')} - #{end_date.strftime('%b %-d, %Y')}"
      end
    else
      "#{start_date.strftime('%b %-d, %Y')} - #{end_date.strftime('%b %-d, %Y')}"
    end
  end
end
