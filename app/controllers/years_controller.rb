class YearsController < ApplicationController
  def current
    @year = query.current_year
    set_data
    render :show
  end

  def index
    @years = current_user.years.where('years.year <= ?', Date.current.year.to_s).order(:year)
  end

  def show
    @year = query.find_or_create_by(year: params[:id])
    @highlight_day = Date.parse(params[:highlight_day]) if params[:highlight_day].present?
    set_data
  end

  def mobile_view
    session[:already_redirected] = true
    @year = current_user.years.current_year
    @current_quarter = @year
      .quarters
      .current
      .includes(quarter_include)
    set_data
  end

  private

  def query
    current_user.years.includes(quarters: [quarter_include])
  end

  def quarter_include
    {
      months: [{
        days: [
          :short_entry,
          :badges,
          be_real_memories: [
            { thumbnail_attachment: :blob }
          ],
          image_attachment: [blob: [variant_records: { image_attachment: :blob }]]
        ]
      }]
    }
  end

  def set_data
    @events = current_user.events.in_range(@year.start_date, @year.end_date)
    @event_dates = @events.flat_map(&:range).uniq
    @year.generate_data if @year.missing_data?
  end
end
