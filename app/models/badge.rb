class Badge < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :icon_name, presence: true
  validates :color, presence: true

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
