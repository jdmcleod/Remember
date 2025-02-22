class Badge < ApplicationRecord
  ADDABLE_COUNT = 5
  belongs_to :user

  validates :name, presence: true
  validates :icon_name, presence: true
  validates :color, presence: true

  has_many :day_badges, dependent: :destroy
  has_many :days, through: :day_badges

  def as_json(options = nil)
    super.merge(dates: days.map(&:date))
  end

  def self.default_badges
    [
      {
        name: 'All smiles',
        icon_name: 'mood-smile-beam',
        color: '#7bc62d'
      },
      {
        name: 'One of those days',
        icon_name: 'mood-sad-2',
        color: '#00bfd8'
      },
      {
        name: 'Lovey dovey',
        icon_name: 'heart',
        color: '#ff2825'
      },
    ]
  end
end
