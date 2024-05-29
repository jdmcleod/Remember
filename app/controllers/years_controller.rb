class YearsController < ApplicationController
  def current
    @year = current_user.years.current_year
    @year.generate_data if @year.missing_data?
  end
end
