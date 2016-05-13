module EmailHelper
  def email_button(body = nil, url = nil, html_options = nil, &block)
    style = '-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;' \
            'color:#FFF;text-decoration: none;cursor: pointer;' \
            'white-space: nowrap;font-weight: 500;font-size: 14px;' \
            'line-height: 14px;letter-spacing: 0.03em;' \
            'text-transform:uppercase;border-top: 1px solid #FF4081;' \
            'border-left: 1px solid #FF4081;border-right: 1px solid #FF4081;' \
            'border-bottom: 1px solid #FF4081;background-color: #FF4081;' \
            'display: inline-block;text-align: center;border-radius: 3px;' \
            'padding: 10px 25px;'

    if block_given?
      options = url ||  {}
      pass_style = options.fetch(:style, '')
      link_to(body, options.update(style: "#{style} #{pass_style}")) { yield }
    else
      options = html_options ||  {}
      pass_style = options.fetch(:style, '')
      link_to body, url, options.update(style: "#{style} #{pass_style}")
    end
  end
end
