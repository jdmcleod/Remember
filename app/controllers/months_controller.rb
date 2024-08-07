class MonthsController < ApplicationController
  def show
    @month = current_user.months.find(params[:id])
    @entries = current_user.entries.in_range(@month.start_date, @month.end_date)
    render layout: 'modal'
  end
end
