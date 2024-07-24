class YearsController < ApplicationController
  def current
    @year = current_user.years.includes(quarters: [{ months: [{ days: :short_entry }] }]).current_year
    @events = current_user.events.in_year(@year)
    @year.generate_data if @year.missing_data?
    render :show
  end

  def show
    year = params[:id]
    @year = current_user.years.includes(quarters: [{ months: [{ days: :short_entry }] }]).find_or_create_by(year:)
    @year.generate_data if @year.missing_data?
  end
end
