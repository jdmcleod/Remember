class YearHighlightsController < ApplicationController
  def add_image_attachment
    @year_highlight = YearHighlight.find(params[:id])
    image = year_highlight_params[:image]
    filename = image.original_filename
    @year_highlight.image.attach(key: storage_key(filename), io: image, filename:)
    @image = @year_highlight.image
  end

  def delete_image_attachment
    @year_highlight = YearHighlight.find(params[:id])
    @year_highlight.image&.purge
  end

  private

  def storage_key(filename)
    "user_#{@year_highlight.user.id}/#{@year_highlight.year.year}/highlights/#{filename}"
  end

  def year_highlight_params
    params.require(:year_highlight).permit(:image, :date)
  end
end
