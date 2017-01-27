require("active_mocker/mock")
class ExportGuideMock < ActiveMocker::Base
  created_with("2.3.0")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new(id: nil, export_id: nil, guide_id: nil, export_version: nil, created_at: nil, updated_at: nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Integer, export_id: Integer, guide_id: Integer, export_version: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { guide: nil, export: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Guide" => { belongs_to: [:guide] }, "Export" => { belongs_to: [:export] } }.merge(super)
    end

    def mocked_class
      "ExportGuide"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= attributes.stringify_keys.keys
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "export_guides" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def export_id
    read_attribute(:export_id)
  end

  def export_id=(val)
    write_attribute(:export_id, val)
  end

  def guide_id
    read_attribute(:guide_id)
  end

  def guide_id=(val)
    write_attribute(:guide_id, val)
  end

  def export_version
    read_attribute(:export_version)
  end

  def export_version=(val)
    write_attribute(:export_version, val)
  end

  def created_at
    read_attribute(:created_at)
  end

  def created_at=(val)
    write_attribute(:created_at, val)
  end

  def updated_at
    read_attribute(:updated_at)
  end

  def updated_at=(val)
    write_attribute(:updated_at, val)
  end

  # _associations.erb
  # belongs_to
  def guide
    read_association(:guide) || write_association(:guide, classes("Guide").try do |k|
      k.find_by(id: guide_id)
    end)
  end

  def guide=(val)
    write_association(:guide, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :guide_id).item
  end

  def build_guide(attributes = {}, &block)
    association = classes("Guide").try(:new, attributes, &block)
    unless association.nil?
      write_association(:guide, association)
    end

  end

  def create_guide(attributes = {}, &block)
    association = classes("Guide").try(:create, attributes, &block)
    unless association.nil?
      write_association(:guide, association)
    end

  end

  alias_method(:create_guide!, :create_guide)
  def export
    read_association(:export) || write_association(:export, classes("Export").try do |k|
      k.find_by(id: export_id)
    end)
  end

  def export=(val)
    write_association(:export, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :export_id).item
  end

  def build_export(attributes = {}, &block)
    association = classes("Export").try(:new, attributes, &block)
    unless association.nil?
      write_association(:export, association)
    end

  end

  def create_export(attributes = {}, &block)
    association = classes("Export").try(:create, attributes, &block)
    unless association.nil?
      write_association(:export, association)
    end

  end

  alias_method(:create_export!, :create_export)
  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(ExportGuideMock::Scopes)
  end

  def self.__new_relation__(collection)
    ExportGuideMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def fail!
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def is_failed?
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

end