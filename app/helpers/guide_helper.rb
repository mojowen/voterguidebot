module GuideHelper

  def to_asset_string(asset)
    asset_string = get_asset(asset)
    asset.downcase.match(/jpg|jpeg|png|gif/) ? Base64.encode64(asset_string) : asset_string
  end

  def to_url_encoded_string(asset)
    asset_string = get_asset(asset)
    asset.downcase.match(/svg/) ? URI.encode(asset_string) : asset_string
  end

  def stance_image(stance)
    return "neutral.png" unless stance
    { "for" => "up.png", "against" => "down.png" }.fetch(stance)
  end

  def markdown(blurb)
    renderer = Redcarpet::Render::HTML.new(
      no_links: true,
      filter_html: true,
      hard_wrap: true
    )
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(blurb)
  end

  private

  def get_asset(asset)
    unless Rails.env.production?
      Rails.application.assets.find_asset(asset).to_s
    else
      path = Rails.application.assets_manifest.assets[asset]
      raise "Cannot find compiled asset #{asset} in manifest" unless path
      File.read(Rails.root.join('public', 'assets', path))
    end
  end
end
