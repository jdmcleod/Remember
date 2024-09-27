class MusingsController < ApplicationController
  before_action :set_day, except: [:in_year]

  def in_year
    year = current_user.years.find_by(year: params[:year_id])
    @musings = current_user.musings.in_range(year.start_date, year.end_date)
    render layout: 'panel'
  end

  def new
    @musing = @day.musings.new
  end

  def edit
    @musing = Musing.find(params[:id])
  end

  def update
    @musing = Musing.find(params[:id])

    if @musing.update(musing_params)
      # turbo
    end
  end

  def create
    @musing = @day.musings.build(musing_params)

    if @musing.save
      # turbo
    end
  end

  def destroy
    @musing = Musing.find(params[:id])

    if @musing.destroy
      # turbo
    end
  end

  private

  def set_day
    @day = Day.find(params[:day_id])
  end

  def musing_params
    params.require(:musing).permit(:name, :description, :type)
  end
end
