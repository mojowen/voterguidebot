require("active_mocker/mock")
class AnswerMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "candidate_id" => nil, "question_id" => nil, "text" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, candidate_id: Fixnum, question_id: Fixnum, text: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { candidate: nil, question: nil, translations: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Candidate" => { belongs_to: [:candidate] }, "Question" => { belongs_to: [:question] }, "Answer::Translation" => { has_many: [:translations] } }.merge(super)
    end

    def mocked_class
      "Answer"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "candidate_id", "question_id", "text", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "answers" || super
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

  def question_id
    read_attribute(:question_id)
  end

  def question_id=(val)
    write_attribute(:question_id, val)
  end

  def text
    read_attribute(:text)
  end

  def text=(val)
    write_attribute(:text, val)
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
  def candidate
    read_association(:candidate) || write_association(:candidate, classes("Candidate").try do |k|
      k.find_by(id: candidate_id)
    end)
  end

  def candidate=(val)
    write_association(:candidate, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :candidate_id).item
  end

  def build_candidate(attributes = {}, &block)
    association = classes("Candidate").try(:new, attributes, &block)
    unless association.nil?
      write_association(:candidate, association)
    end

  end

  def create_candidate(attributes = {}, &block)
    association = classes("Candidate").try(:create, attributes, &block)
    unless association.nil?
      write_association(:candidate, association)
    end

  end

  alias_method(:create_candidate!, :create_candidate)
  def question
    read_association(:question) || write_association(:question, classes("Question").try do |k|
      k.find_by(id: question_id)
    end)
  end

  def question=(val)
    write_association(:question, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :question_id).item
  end

  def build_question(attributes = {}, &block)
    association = classes("Question").try(:new, attributes, &block)
    unless association.nil?
      write_association(:question, association)
    end

  end

  def create_question(attributes = {}, &block)
    association = classes("Question").try(:create, attributes, &block)
    unless association.nil?
      write_association(:question, association)
    end

  end

  alias_method(:create_question!, :create_question)
  # has_many
  def translations
    read_association(:translations, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "answer_id", foreign_id: self.id, relation_class: classes("Answer::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "answer_id", foreign_id: self.id, relation_class: classes("Answer::Translation"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(AnswerMock::Scopes)
  end

  def self.__new_relation__(collection)
    AnswerMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

end