require("active_mocker/mock")
class MeasureMock < ActiveMocker::Base
  created_with("2.3.0")
  # _modules_constants.erb
  prepend(Endorsements)
  prepend(Tags)
  prepend(Stance)
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new(id: nil, guide_id: nil, title: nil, description: nil, yes_means: nil, no_means: nil, created_at: nil, updated_at: nil, position: nil, stance: nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Integer, guide_id: Integer, title: String, description: String, yes_means: String, no_means: String, created_at: DateTime, updated_at: DateTime, position: Integer, stance: Integer }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { guide: nil, audits: nil, translations: nil, endorsements: nil, tags: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Guide" => { belongs_to: [:guide] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] }, "Measure::Translation" => { has_many: [:translations] }, "Endorsement" => { has_many: [:endorsements] }, "Tag" => { has_many: [:tags] } }.merge(super)
    end

    def mocked_class
      "Measure"
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
      "measures" || super
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

  def title
    read_attribute(:title)
  end

  def title=(val)
    write_attribute(:title, val)
  end

  def description
    read_attribute(:description)
  end

  def description=(val)
    write_attribute(:description, val)
  end

  def yes_means
    read_attribute(:yes_means)
  end

  def yes_means=(val)
    write_attribute(:yes_means, val)
  end

  def no_means
    read_attribute(:no_means)
  end

  def no_means=(val)
    write_attribute(:no_means, val)
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

  def position
    read_attribute(:position)
  end

  def position=(val)
    write_attribute(:position, val)
  end

  def stance
    read_attribute(:stance)
  end

  def stance=(val)
    write_attribute(:stance, val)
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
      ActiveMocker::HasMany.new([], foreign_key: "measure_id", foreign_id: self.id, relation_class: classes("Measure::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "measure_id", foreign_id: self.id, relation_class: classes("Measure::Translation"), source: ""))
  end

  def endorsements
    read_association(:endorsements, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "endorsed_id", foreign_id: self.id, relation_class: classes("Endorsement"), source: "")
    end)
  end

  def endorsements=(val)
    write_association(:endorsements, ActiveMocker::HasMany.new(val, foreign_key: "endorsed_id", foreign_id: self.id, relation_class: classes("Endorsement"), source: ""))
  end

  def tags
    read_association(:tags, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "tagged_id", foreign_id: self.id, relation_class: classes("Tag"), source: "")
    end)
  end

  def tags=(val)
    write_association(:tags, ActiveMocker::HasMany.new(val, foreign_key: "tagged_id", foreign_id: self.id, relation_class: classes("Tag"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(MeasureMock::Scopes)
  end

  def self.__new_relation__(collection)
    MeasureMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def as_json(options = nil)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [options])
  end

  def assign_attributes(attributes)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [attributes])
  end

  def full_clone
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def slug
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

  def template(*args, &block)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [args, block])
  end

end