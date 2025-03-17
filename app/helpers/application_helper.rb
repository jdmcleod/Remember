module ApplicationHelper
  include IconHelper

  def icon_name_for_flash(type)
    case type
    when 'notice'
      'circle-check'
    when 'alert'
      'alert-circle'
    else
      type
    end
  end

  def icon_color_for_flash(type)
    case type
    when 'notice'
      'alerts-notice-base'
    when 'alert'
      'alerts-danger-base'
    else
      type
    end
  end

  def tab_link_to(name, path)
    link_to(name, path, active_tab(path))
  end

  def active_tab(path)
    request.path.match(/^#{path}/) ? { class: 'tab tab--active' } : { class: 'tab' }
  end

  def highlight_search_result(text, highlight_matcher)
    highlight_matcher = sanitize(highlight_matcher.to_s)
    highlight(text, highlight_matcher, highlighter: '<span class="search-highlight">\1</span>')
  end
end
