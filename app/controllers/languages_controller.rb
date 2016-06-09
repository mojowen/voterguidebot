class LanguagesController < ApplicationController
  include GuideFinder

  def create
    @lang = Language.create(language_params)
    @lang.guide = @guide

    if @lang.save
      notice = "Added #{@lang.name}"
    else
      alert = "Hmm couldn't add #{@lang.name}"
    end
    redirect_to guide_path(@guide, { locale: @lang.code } ), notice: notice, alert: alert
  end

  def destroy
    @lang = @guide.languages.find(params[:id])
    @lang.destroy
    redirect_to guide_languages_path(@guide, { locale: nil } ), notice: "Removed #{@lang.name}"
  end

  private

  def language_params
    params.require(:language).permit(:code)
  end
end
