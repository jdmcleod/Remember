class MusingsController < ApplicationController
  before_action :set_type
  before_action :set_collection, only: %i[in_year create]
  before_action :find_musing, only: %i[edit update show destroy delete_image_attachment]

  def in_year
    @year = current_user.years.find(params[:year_id])
    @musings = @collection.in_range(@year.start_date, @year.end_date)
    render layout: 'panel'
  end

  def edit
  end

  def update
    if musing_params[:image].present?
      image = musing_params[:image]
      filename = image.original_filename
      @musing.image.attach(key: storage_key(filename), io: image, filename:)
    end

    if @musing.update(musing_params)
      render turbo_stream: [
        turbo_stream.update(
          'image-uploader',
          partial: 'shared/image-uploader',
          locals: {  resource: @musing, delete_path: delete_image_attachment_musing_path(@musing), upload_path: musing_path(@musing) } )
      ]
    else

    end
  end

  def create
    @musing = @collection.build(musing_params)

    if @musing.save
      render turbo_stream: turbo_stream.append(:musings, @musing)
    end
  end

  def show
    render layout: 'modal'
  end

  def destroy
    if @musing.destroy
      # turbo
    end
  end

  def delete_image_attachment
    @musing.image&.purge
    render turbo_stream: turbo_stream.update('musing-image', 'musings/image')
  end

  private

  def set_type
    @type = params[:type]
  end

  def set_collection
    @collection ||= current_user.public_send(@type.to_s.pluralize)
  end

  def find_musing
    @musing = current_user.public_send(@type.to_s.pluralize).find(params[:id])
  end

  def storage_key(filename)
    "user_#{current_user.id}/#{@musing.date.year}/#{@musing.kind.to_s}/#{filename}"
  end

  def musing_params
    params.require(@type).permit(:name, :date, :image, custom_fields: {})
  end
end
