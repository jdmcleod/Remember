require 'open-uri'

class BeRealMemory < ApplicationRecord
  belongs_to :day

  has_one_attached :primary
  has_one_attached :secondary
  has_one_attached :thumbnail

  def attach_image_from(url, image_name = :primary)
    downloaded_image = URI.parse(url).open
    filename = "#{image_name}.webp"
    send(image_name).attach(key: storage_key(filename), io: downloaded_image, filename:)
  end

  def thumbnail_url
    Rails.cache.fetch([thumbnail.cache_key, 'url']) do
      Rails.application.routes.url_helpers.rails_storage_proxy_path thumbnail, only_path: true
    end
  end

  def storage_key(filename)
    "user_#{day.user.id}/#{day.date.year}/be_real/#{day.date.to_s}/#{filename}"
  end
end
