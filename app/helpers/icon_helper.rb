# frozen_string_literal: true

module IconHelper
  # Utilizes Tabler Icons: https://tabler-icons.io/
  def icon(name, classes: nil, color: nil, title: nil)
    options = {
      class: [classes, 'icon ti', "ti-#{name}"],
      title:,
      'aria-label': title,
    }
    options[:style] = "color: var(--op-color-#{color})" if color

    tag.span('', **options)
  end
end
