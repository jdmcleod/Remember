require 'open-uri'

class BeRealMemory < ApplicationRecord
  belongs_to :day

  has_one_attached :primary
  has_one_attached :secondary
  has_one_attached :thumbnail

  def attach_image_from(url, image_name = :primary)
    downloaded_image = URI.parse(url).open
    send(image_name).attach(io: downloaded_image, filename: "#{image_name}.webp")
  end

  def thumbnail_url
    Rails.cache.fetch([thumbnail.cache_key, 'url']) do
      Rails.application.routes.url_helpers.rails_storage_proxy_path thumbnail, only_path: true
    end
  end
end
