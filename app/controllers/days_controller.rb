class DaysController < ApplicationController
  def update
    @day = Day.find_by(id: params[:id])
    @day.update(day_params)

    render turbo_stream: turbo_stream.replace('day-popup-form', partial: 'entries/day_popup_form')
  end

  private

  def day_params
    params.require(:day).permit(:badges)
  end
end
