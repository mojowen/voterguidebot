require("active_mocker/mock")
class QuestionMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "contest_id" => nil, "text" => nil, "publish" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, contest_id: Fixnum, text: String, publish: Axiom::Types::Boolean, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { contest: nil, guide: nil, audits: nil, translations: nil, answers: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Contest" => { belongs_to: [:contest] }, "Guide" => { has_one: [:guide] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] }, "Question::Translation" => { has_many: [:translations] }, "Answer" => { has_many: [:answers] } }.merge(super)
    end

    def mocked_class
      "Question"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "contest_id", "text", "publish", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "questions" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def contest_id
    read_attribute(:contest_id)
  end

  def contest_id=(val)
    write_attribute(:contest_id, val)
  end

  def text
    read_attribute(:text)
  end

  def text=(val)
    write_attribute(:text, val)
  end

  def publish
    read_attribute(:publish)
  end

  def publish=(val)
    write_attribute(:publish, val)
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
  def contest
    read_association(:contest) || write_association(:contest, classes("Contest").try do |k|
      k.find_by(id: contest_id)
    end)
  end

  def contest=(val)
    write_association(:contest, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :contest_id).item
  end

  def build_contest(attributes = {}, &block)
    association = classes("Contest").try(:new, attributes, &block)
    unless association.nil?
      write_association(:contest, association)
    end

  end

  def create_contest(attributes = {}, &block)
    association = classes("Contest").try(:create, attributes, &block)
    unless association.nil?
      write_association(:contest, association)
    end

  end

  alias_method(:create_contest!, :create_contest)
  # has_one
  def guide
    read_association(:guide)
  end

  def guide=(val)
    write_association(:guide, val)
    ActiveMocker::HasOne.new(val, child_self: self, foreign_key: "guide_id").item
  end

  def build_guide(attributes = {}, &block)
    if classes("Guide")
      write_association(:guide, classes("Guide").new(attributes, &block))
    end

  end

  def create_guide(attributes = {}, &block)
    if classes("Guide")
      write_association(:guide, classes("Guide").new(attributes, &block))
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
      ActiveMocker::HasMany.new([], foreign_key: "question_id", foreign_id: self.id, relation_class: classes("Question::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "question_id", foreign_id: self.id, relation_class: classes("Question::Translation"), source: ""))
  end

  def answers
    read_association(:answers, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "question_id", foreign_id: self.id, relation_class: classes("Answer"), source: "")
    end)
  end

  def answers=(val)
    write_association(:answers, ActiveMocker::HasMany.new(val, foreign_key: "question_id", foreign_id: self.id, relation_class: classes("Answer"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(QuestionMock::Scopes)
  end

  def self.__new_relation__(collection)
    QuestionMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

end