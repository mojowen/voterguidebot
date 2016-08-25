module AvgHelper

  def how_to_vote_video(guide)
    state_config(guide)['video']
  end

  def state_pic(guide)
    state_config(guide)['pic']
  end

  private

  def state_config(guide)
    guide.template.states[guide.location.state]
  end
end
