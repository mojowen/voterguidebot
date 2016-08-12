module ApplicationHelper
  def button_link_to(body = nil, url = nil, html_options = nil, &block)
    if block_given?
      options = url ||  {}
      passed_class = options.fetch(:class, '')
      btn_passed_class = options.fetch(:btn, 'accent')
      link_to(body, options.update(class: "mui-btn mui-btn--#{btn_passed_class} #{passed_class}")) { yield }
    else
      options = html_options ||  {}
      passed_class = options.fetch(:class, '')
      btn_passed_class = options.fetch(:btn, 'accent')
      link_to body, url, options.update(class: "mui-btn mui-btn--#{btn_passed_class} #{passed_class}")
    end
  end

  def to_rgba(hex_val, alpha = 1)
    return unless hex_val
    hex_val = hex_val.gsub(/\#/,'')
    hex_val += hex_val if hex_val.length < 6
    rgb = {}
    %w(r g b).inject(hex_val.hex) {|a,i| rest, rgb[i] = a.divmod 256; rest }

    "rgba(#{rgb.values.reverse.join(', ')}, #{alpha})"
  end
end
