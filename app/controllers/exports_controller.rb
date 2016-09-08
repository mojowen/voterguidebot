class ExportsController < ApplicationController
  before_filter :init_export, only: [:create, :new]
  before_filter :guides, only: :new
  before_filter :export_params, only: :create
  before_filter :find_export, only: [:show, :update]

  def create
    @export.assign_attributes guides: export_params

    if @export.valid?
      @export.start_publishing
      redirect_to exports_path, notice: 'Export started'
    else
      redirect_to new_export_path, notice: @export.errors.full_message
    end
  end

  def update
    @export.start_publishing
    redirect_to exports_path, notice: 'Export restarted'
  end

  private

  def export_params
    params.require(:export)

    params[:export][:guides].reject { |key, val| val != '1' }
                            .map { |key, _| Guide.find(key) }
                            .select { |guide| current_user.can_edit?(guide) }
  end

  def find_export
    @export = current_user.exports.find(params[:id])
  end

  def init_export
    @export = current_user.exports.new
  end

  def guides
    @guides = if current_user.admin
      Guide.where.not(published_version: %w{unpublished publishing-failed})
    else
      current_user.guides.select(&:is_published?)
    end.select{ |guide| guide.template.publisher_type == 'pdf' }
  end
end
