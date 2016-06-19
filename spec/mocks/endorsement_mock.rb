require("active_mocker/mock")
class EndorsementMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "endorsing_id" => nil, "endorsing_type" => nil, "endorser" => nil, "created_at" => nil, "updated_at" => nil, "stance" => 0).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, endorsing_id: Fixnum, endorsing_type: String, endorser: String, created_at: DateTime, updated_at: DateTime, stance: Fixnum }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { audits: nil, translations: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] }, "Endorsement::Translation" => { has_many: [:translations] } }.merge(super)
    end

    def mocked_class
      "Endorsement"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "endorsing_id", "endorsing_type", "endorser", "created_at", "updated_at", "stance"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "endorsements" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def endorsing_id
    read_attribute(:endorsing_id)
  end

  def endorsing_id=(val)
    write_attribute(:endorsing_id, val)
  end

  def endorsing_type
    read_attribute(:endorsing_type)
  end

  def endorsing_type=(val)
    write_attribute(:endorsing_type, val)
  end

  def endorser
    read_attribute(:endorser)
  end

  def endorser=(val)
    write_attribute(:endorser, val)
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

  def stance
    read_attribute(:stance)
  end

  def stance=(val)
    write_attribute(:stance, val)
  end

  # _associations.erb
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
      ActiveMocker::HasMany.new([], foreign_key: "endorsement_id", foreign_id: self.id, relation_class: classes("Endorsement::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "endorsement_id", foreign_id: self.id, relation_class: classes("Endorsement::Translation"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(EndorsementMock::Scopes)
  end

  def self.__new_relation__(collection)
    EndorsementMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def guide
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

end