class YearsController < ApplicationController
  def current
    @year = current_user.years.current_year
  end
end
