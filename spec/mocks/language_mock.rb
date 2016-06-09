require("active_mocker/mock")
class LanguageMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  LANGUAGES = { ar: "Arabic", zh: "Chinese", ko: "Korean", ja: "Japanese", es: "Spanish" }
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "guide_id" => nil, "code" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, guide_id: Fixnum, code: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { audits: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] } }.merge(super)
    end

    def mocked_class
      "Language"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "guide_id", "code", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "languages" || super
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

  def code
    read_attribute(:code)
  end

  def code=(val)
    write_attribute(:code, val)
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
  def audits
    read_association(:audits, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: "")
    end)
  end

  def audits=(val)
    write_association(:audits, ActiveMocker::HasMany.new(val, foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(LanguageMock::Scopes)
  end

  def self.__new_relation__(collection)
    LanguageMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def name
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [])
  end

end