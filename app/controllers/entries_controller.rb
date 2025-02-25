class EntriesController < ApplicationController
  def update
    @entry = Entry.find_by(id: params[:id])
    @entry.update(entry_params)

    month = current_user.months.contains_date(@entry.date).first
    render turbo_stream: turbo_stream.replace("month-#{month.number}", partial: 'months/month', locals: { month: })
  end

  def search
    @search_term = params[:q]
    @entries = current_user.entries.order(:date).includes(journalable: [{ be_real_memories: [{ primary_attachment: :blob, secondary_attachment: :blob }] }])

    if search_date
      @entries = @entries.where("date(date) = ?", search_date)
    elsif params[:year_id].present?
      @year = Year.find(params[:year_id])
      @entries = @entries.in_range(@year.start_date, @year.end_date).search(@search_term)
    else
      @entries = @entries.search(@search_term)
    end

    render layout: 'modal', locals: { modal_class: 'modal--full' }
  end

  private

  def search_date
    begin
      @search_date ||= Date.parse(@search_term)
    rescue ArgumentError
    end
  end

  def entry_params
    params.require(:entry).permit(:content)
  end
end
