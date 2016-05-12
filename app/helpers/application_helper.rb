module ApplicationHelper
  def button_link_to(body = nil, url = nil, html_options = nil, &block)
    if block_given?
      options = url ||  {}
      passed_class = options.fetch(:class, '')
      link_to(body, options.update(class: "mui-btn mui-btn--accent #{passed_class}")) { yield }
    else
      options = html_options ||  {}
      passed_class = options.fetch(:class, '')
      link_to body, url, options.update(class: "mui-btn mui-btn--accent #{passed_class}")
    end
  end
end
