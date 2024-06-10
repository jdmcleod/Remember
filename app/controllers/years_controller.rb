class YearsController < ApplicationController
  def current
    @year = current_user.years.includes(quarters: [{ months: [{ days: :short_entry }] }]).current_year
    @year.generate_data if @year.missing_data?
  end
end
