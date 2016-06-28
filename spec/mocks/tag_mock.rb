require("active_mocker/mock")
class TagMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "tagged_id" => nil, "tagged_type" => nil, "name" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, tagged_id: Fixnum, tagged_type: String, name: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {}.merge(super)
    end

    def mocked_class
      "Tag"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "tagged_id", "tagged_type", "name", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "tags" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def tagged_id
    read_attribute(:tagged_id)
  end

  def tagged_id=(val)
    write_attribute(:tagged_id, val)
  end

  def tagged_type
    read_attribute(:tagged_type)
  end

  def tagged_type=(val)
    write_attribute(:tagged_type, val)
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
  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(TagMock::Scopes)
  end

  def self.__new_relation__(collection)
    TagMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

end