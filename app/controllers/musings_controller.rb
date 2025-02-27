class MusingsController < ApplicationController
  before_action :set_kind

  def in_year
    year = current_user.years.find(params[:year_id])
    @musings = current_user.musings.in_range(year.start_date, year.end_date)
    render layout: 'panel'
  end

  def new
    @musing = current_user.musings.new(kind: @kind)
    render layout: 'modal'
  end

  def edit
    @musing = Musing.find(params[:id])
  end

  def update
    @musing = Musing.find(params[:id])

    if musing_params[:image].present?
      image = musing_params[:image]
      filename = image.original_filename
      @musing.image.attach(key: storage_key(filename), io: image, filename:)
    end

    if @musing.update(musing_params)
      render turbo_stream: [
        turbo_stream.update(@musing),
        turbo_stream.update(
          'image-uploader',
          partial: 'shared/image-ploader',
          locals: {  resource: @musing, delete_path: delete_image_attachment_musing_path(@musing), upload_path: musing_path(@musing) } )
      ]
    else

    end
  end

  def create
    @musing = current_user.musings.build(musing_params)

    ActiveRecord::Base.transaction do |transaction|
      @musing.save

      if musing_params[:image].present?
        image = musing_params[:image]
        filename = image.original_filename
        @musing.image.attach(key: storage_key(filename), io: image, filename:)
      end

      transaction.after_commit do
        flash.now[:notice] = "Created new #{@musing.kind_humanized}"

        render turbo_stream: [
          turbo_stream.update('modal'),
          turbo_stream.update('flash', partial: 'shared/flash')
        ]
      end

      transaction.after_rollback do
        render turbo_stream: turbo_stream.update('modal-body', partial: 'musings/form')
      end
    end
  end

  def show
    @musing = Musing.find(params[:id])
    render layout: 'modal'
  end

  def destroy
    @musing = Musing.find(params[:id])

    if @musing.destroy
      # turbo
    end
  end

  def delete_image_attachment
    @musing = Musing.find(params[:id])
    @musing.image&.purge

    render turbo_stream: turbo_stream.update('musing-image', 'musings/image')
  end

  private

  def set_kind
    @kind = params[:kind]
  end

  def storage_key(filename)
    "user_#{current_user.id}/#{@musing.date.year}/#{@musing.kind.to_s}/#{filename}"
  end

  def musing_params
    params.require(:musing).permit(:name, :description, :date, :kind, :image)
  end
end
