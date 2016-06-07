require("active_mocker/mock")
class EndorsementMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "candidate_id" => nil, "endorser" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, candidate_id: Fixnum, endorser: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { translations: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Endorsement::Translation" => { has_many: [:translations] } }.merge(super)
    end

    def mocked_class
      "Endorsement"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "candidate_id", "endorser", "created_at", "updated_at"] | super)
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

  def candidate_id
    read_attribute(:candidate_id)
  end

  def candidate_id=(val)
    write_attribute(:candidate_id, val)
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

  # _associations.erb
  # has_many
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

end