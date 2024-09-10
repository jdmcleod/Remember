class YearsController < ApplicationController
  def current
    @year = query.current_year
    set_data
    render :show
  end

  def show
    @year = query.find_or_create_by(year: params[:id])
    set_data
  end

  private

  def query
    current_user.years.includes(quarters: [{ months: [{ days: [:short_entry, :badges, be_real_memories: [{ thumbnail_attachment: :blob }]] }] }])
  end

  def set_data
    @events = current_user.events.in_range(@year.start_date, @year.end_date)
    @event_dates = @events.flat_map(&:range).uniq
    @year.generate_data if @year.missing_data?
  end
end
