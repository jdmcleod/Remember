class EntriesController < ApplicationController
  def update
    @entry = Entry.find_by(id: params[:id])

    if @entry.update(entry_params)
      update_month_ui
    else
      flash.now[:alert] = "Failed to update entry"
      render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash')
    end
  end

  def create
    if entry_params[:content].empty?
      return render head: :ok
    end

    @entry = current_user.entries.build(entry_params)

    if @entry.save
      update_month_ui
    else
      flash.now[:alert] = "Failed to update entry"
      render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash')
    end
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

  def update_month_ui
    flash.now[:alert] = "Updated entry on #{@entry.date&.strftime("%B %d, %Y")}"

    month = current_user.months.contains_date(@entry.date).first
    @events = current_user
                .events
                .in_range(month.start_date, month.end_date)
                .order(:start_date)
    @event_dates = @events.flat_map(&:range).uniq
    render turbo_stream: [
      turbo_stream.replace('flash', partial: 'shared/flash'),
      turbo_stream.replace("month-#{month.number}", partial: 'months/month', locals: { month: })
    ].join
  end

  def search_date
    begin
      @search_date ||= Date.parse(@search_term)
    rescue ArgumentError
    end
  end

  def entry_params
    params.require(:entry).permit(:content, :date, :user_id, :journalable_id, :journalable_type)
  end
end
