module ApplicationHelper
  include IconHelper

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
