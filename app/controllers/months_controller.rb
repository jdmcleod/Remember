class MonthsController < ApplicationController
  def show
    @month = current_user.months.find(params[:id])
    @entries = current_user.entries.where(journalable_type: 'Day').in_range(@month.start_date, @month.end_date)
    render layout: 'modal', locals: { modal_class: 'modal--full' }
  end

  def entry_form
    @month = current_user.months.find(params[:id])
    @entry = @month.find_entry
    render layout: 'modal', locals: { modal_class: 'modal--full' }
  end

  def update_entry
    @month = current_user.months.find(params[:id])
    if @month.entry.update(month_entry_params)
      flash.now[:notice] = 'Updated month entry'
      render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash')
    else
      flash.now[:notice] = 'Failed to update entry'
      render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash')
    end
  end

  private

  def month_entry_params
    params.require(:entry).permit(:content)
  end
end
