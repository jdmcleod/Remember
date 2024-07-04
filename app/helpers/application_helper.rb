module ApplicationHelper
  include IconHelper

  def tab_link_to(name, path)
    link_to(name, path, active_tab(path))
  end

  def active_tab(path)
    request.path.match(/^#{path}/) ? { class: 'tab tab--active' } : { class: 'tab' }
  end
end
