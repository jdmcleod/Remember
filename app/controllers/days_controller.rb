class DaysController < ApplicationController
  def add_badge
    @day = Day.find(params[:id])
    @day.badges << Badge.find(params[:badge_id])

    set_badges
  end

  def remove_badge
    @day = Day.find(params[:id])
    DayBadge.find_by(day_id: @day.id, badge_id: params[:badge_id]).destroy

    set_badges
  end

  def add_image_attachment
    @day = Day.find(params[:id])
    image = day_params[:image]
    filename = image.original_filename
    @day.image.attach(key: storage_key(filename), io: image, filename:)
    @image = @day.image
  end

  def delete_image_attachment
    @day = Day.find(params[:id])
    @day.image&.purge
    @memories = @day.be_real_memories
  end

  private

  def set_badges
    @day_badges = @day.badges
    @addable_badges = current_user.badges - @day_badges
    @recommended_badges = @day_badges.count >= 7 ? [] : @addable_badges.first(7  - @day_badges.count)
  end

  def storage_key(filename)
    "user_#{@day.user.id}/#{@day.date.year}/image/#{@day.date.to_s}/#{filename}"
  end

  def day_params
    params.require(:day).permit(:image)
  end
end
