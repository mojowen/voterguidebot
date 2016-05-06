module ApplicationHelper
  def button_link_to(body, url, html_options = {})
    link_to body, url, { class: 'mui-btn mui-btn--accent' }.update(html_options)
  end
end
