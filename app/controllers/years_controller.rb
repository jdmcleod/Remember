class YearsController < ApplicationController
  def current
    @year = query.current_year
    set_data
    check_mobile
    render :show
  end

  def index
    @years = current_user.years.where('years.year <= ?', Date.current.year.to_s).order(:year)
  end

  def show
    @year = query.find_or_create_by(year: params[:id])
    check_mobile
    set_data
  end

  def mobile_view
    if session[:last_redirected_mobile].present?
      if (Time.now - session[:last_redirected_mobile]) > 5.minutes
        session[:last_redirected_mobile] = Time.now.to_i
      end
    end
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

    if params[:highlight_day].present?
      @highlight_day = Date.parse(params[:highlight_day])
    end
  end

  def check_mobile
    @should_redirect_to_mobile = (Time.now.to_i - (session[:last_redirected_mobile] || 0)) > 5.minutes
  end
end
