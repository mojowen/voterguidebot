require("active_mocker/mock")
class GuideMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "name" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, name: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { location: nil, audits: nil, associated_audits: nil, permissions: nil, users: nil, contests: nil, languages: nil, fields: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Location" => { has_one: [:location] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits, :associated_audits] }, "Permission" => { has_many: [:permissions] }, "User" => { has_many: [:users] }, "Contest" => { has_many: [:contests] }, "Language" => { has_many: [:languages] }, "Field" => { has_many: [:fields] } }.merge(super)
    end

    def mocked_class
      "Guide"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "name", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "guides" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def name
    read_attribute(:name)
  end

  def name=(val)
    write_attribute(:name, val)
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
  # has_one
  def location
    read_association(:location)
  end

  def location=(val)
    write_association(:location, val)
    ActiveMocker::HasOne.new(val, child_self: self, foreign_key: "guide_id").item
  end

  def build_location(attributes = {}, &block)
    if classes("Location")
      write_association(:location, classes("Location").new(attributes, &block))
    end

  end

  def create_location(attributes = {}, &block)
    if classes("Location")
      write_association(:location, classes("Location").new(attributes, &block))
    end

  end

  alias_method(:create_location!, :create_location)
  # has_many
  def audits
    read_association(:audits, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: "")
    end)
  end

  def audits=(val)
    write_association(:audits, ActiveMocker::HasMany.new(val, foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: ""))
  end

  def associated_audits
    read_association(:associated_audits, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "associated_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: "")
    end)
  end

  def associated_audits=(val)
    write_association(:associated_audits, ActiveMocker::HasMany.new(val, foreign_key: "associated_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: ""))
  end

  def permissions
    read_association(:permissions, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Permission"), source: "")
    end)
  end

  def permissions=(val)
    write_association(:permissions, ActiveMocker::HasMany.new(val, foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Permission"), source: ""))
  end

  def users
    read_association(:users, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "user_id", foreign_id: self.id, relation_class: classes("User"), source: "")
    end)
  end

  def users=(val)
    write_association(:users, ActiveMocker::HasMany.new(val, foreign_key: "user_id", foreign_id: self.id, relation_class: classes("User"), source: ""))
  end

  def contests
    read_association(:contests, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Contest"), source: "")
    end)
  end

  def contests=(val)
    write_association(:contests, ActiveMocker::HasMany.new(val, foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Contest"), source: ""))
  end

  def languages
    read_association(:languages, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Language"), source: "")
    end)
  end

  def languages=(val)
    write_association(:languages, ActiveMocker::HasMany.new(val, foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Language"), source: ""))
  end

  def fields
    read_association(:fields, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Field"), source: "")
    end)
  end

  def fields=(val)
    write_association(:fields, ActiveMocker::HasMany.new(val, foreign_key: "guide_id", foreign_id: self.id, relation_class: classes("Field"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(GuideMock::Scopes)
  end

  def self.__new_relation__(collection)
    GuideMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def template
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def template_field_names
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def template_fields
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def template_fields=(fields_obj)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [fields_obj])
  end

end