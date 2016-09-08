require("active_mocker/mock")
class ExportMock < ActiveMocker::Base
  created_with("2.3.0")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new(id: nil, user_id: nil, status: 0, created_at: nil, updated_at: nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Integer, user_id: Integer, status: Integer, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { user: nil, export_guides: nil, guides: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "User" => { belongs_to: [:user] }, "ExportGuide" => { has_many: [:export_guides] }, "Guide" => { has_many: [:guides] } }.merge(super)
    end

    def mocked_class
      "Export"
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
      "exports" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
  end

  def status
    read_attribute(:status)
  end

  def status=(val)
    write_attribute(:status, val)
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
  def user
    read_association(:user) || write_association(:user, classes("User").try do |k|
      k.find_by(id: user_id)
    end)
  end

  def user=(val)
    write_association(:user, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
  end

  def build_user(attributes = {}, &block)
    association = classes("User").try(:new, attributes, &block)
    unless association.nil?
      write_association(:user, association)
    end

  end

  def create_user(attributes = {}, &block)
    association = classes("User").try(:create, attributes, &block)
    unless association.nil?
      write_association(:user, association)
    end

  end

  alias_method(:create_user!, :create_user)
  # has_many
  def export_guides
    read_association(:export_guides, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "export_id", foreign_id: self.id, relation_class: classes("ExportGuide"), source: "")
    end)
  end

  def export_guides=(val)
    write_association(:export_guides, ActiveMocker::HasMany.new(val, foreign_key: "export_id", foreign_id: self.id, relation_class: classes("ExportGuide"), source: ""))
  end

  def guides
    read_association(:guides, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Guide"), source: "")
    end)
  end

  def guides=(val)
    write_association(:guides, ActiveMocker::HasMany.new(val, foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Guide"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(ExportMock::Scopes)
  end

  def self.__new_relation__(collection)
    ExportMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def is_synced?
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def key
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def publish
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def start_publishing
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def url
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

end