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
      @associations ||= { permissions: nil, users: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Permission" => { has_many: [:permissions] }, "User" => { has_many: [:users] } }.merge(super)
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
  # has_many
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

end