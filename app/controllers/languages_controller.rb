class LanguagesController < ApplicationController
  include GuideFinder

  def show
    @lang = params[:id] == 'en' ? english : Language.find(params[:id])
    redirect_to guide_languages_path(@guide, { locale: @lang.code } ), notice: "Activated #{@lang.name}"
  end

  def create
    @lang = Language.create(language_params)
    @lang.guide = @guide

    if @lang.save
      notice = "Added & Activated #{@lang.name}"
    else
      alert = "Hmm couldn't add #{@lang.name}"
    end
    redirect_to guide_languages_path(@guide, { locale: @lang.code } ), notice: notice, alert: alert
  end

  def destroy
    @lang = @guide.languages.find(params[:id])
    @lang.destroy
    redirect_to guide_languages_path(@guide, { locale: nil } ), notice: "Removed #{@lang.name}"
  end

  private

  def english
    OpenStruct.new(name: 'English', code: nil)
  end

  def language_params
    params.require(:language).permit(:code)
  end
end
