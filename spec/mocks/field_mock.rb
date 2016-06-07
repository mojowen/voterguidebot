require("active_mocker/mock")
class FieldMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "guide_id" => nil, "value" => nil, "field_template" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, guide_id: Fixnum, value: String, field_template: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { guide: nil, audits: nil, translations: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Guide" => { belongs_to: [:guide] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] }, "Field::Translation" => { has_many: [:translations] } }.merge(super)
    end

    def mocked_class
      "Field"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "guide_id", "value", "field_template", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "fields" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def guide_id
    read_attribute(:guide_id)
  end

  def guide_id=(val)
    write_attribute(:guide_id, val)
  end

  def value
    read_attribute(:value)
  end

  def value=(val)
    write_attribute(:value, val)
  end

  def field_template
    read_attribute(:field_template)
  end

  def field_template=(val)
    write_attribute(:field_template, val)
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
  # has_many
  def audits
    read_association(:audits, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: "")
    end)
  end

  def audits=(val)
    write_association(:audits, ActiveMocker::HasMany.new(val, foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: ""))
  end

  def translations
    read_association(:translations, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "field_id", foreign_id: self.id, relation_class: classes("Field::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "field_id", foreign_id: self.id, relation_class: classes("Field::Translation"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(FieldMock::Scopes)
  end

  def self.__new_relation__(collection)
    FieldMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def template(*args, &block)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [args, block])
  end

end