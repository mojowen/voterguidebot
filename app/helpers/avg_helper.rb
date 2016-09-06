module AvgHelper

  def how_to_vote_video(guide)
    state_config(guide)['video']
  end

  def state_pic(guide)
    state_config(guide)['pic']
  end

  def avg_asset_path(asset)
    asset = asset.split('/').last
    asset = Rails.application.assets_manifest.assets[asset] if Rails.env.production? && preview
    "/assets/#{asset}"
  end

  private

  def state_config(guide)
    guide.template.states[guide.location.state]
  end
end
