module AvgHelper

  def how_to_vote_video(guide)
    if guide.template_name == 'state'
      state_config(guide)['video']
    else
      video = guide.field('how_to_vote_video')
      video == 'no_video' ? nil : video
    end
  end

  def header_pic(guide)
    if guide.template_name == 'state'
      "https://s3-us-west-2.amazonaws.com/voterguides/states/#{state_config(guide)['pic']}"
    else
      guide.field('header_pic')
    end
  end

  def avg_asset_path(asset, preview)
    asset = asset.split('/').last
    asset = Rails.application.assets_manifest.assets[asset] if Rails.env.production? && preview
    "/assets/#{asset}"
  end

  private

  def state_config(guide)
    guide.template.states[guide.location.state]
  end
end
