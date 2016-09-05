module GuideHelper

  def to_asset_string(asset)
    asset_string = get_asset(asset)
    asset.downcase.match(/jpg|jpeg|png|gif/) ? Base64.encode64(asset_string) : asset_string
  end

  private

  def get_asset(asset)
    unless Rails.env.production?
      Rails.application.assets.find_asset(asset).to_s
    else
      Rails.application.assets_manifest.assets[asset]
      File.read(Rails.root.join('public', 'assets', path))
    end
  end
end
