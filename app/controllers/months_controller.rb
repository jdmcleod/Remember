class MonthsController < ApplicationController
  def show
    @month = current_user.months.find(params[:id])
    @entries = current_user.entries.in_range(@month.start_date, @month.end_date)
    render layout: 'modal'
  end

  def entry_form
    @month = current_user.months.find(params[:id])
    @entry = @month.find_entry
    render layout: 'modal'
  end

  def update_entries
    @month = current_user.months.find(params[:id])
    binding.pry
    @month.update(month_entry_params)
  end

  private

  def month_entry_params
    params.require(:entry).permit(:content)
  end
end
