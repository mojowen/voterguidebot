require("active_mocker/mock")
class LocationMock < ActiveMocker::Base
  created_with("2.2.2")
  # _modules_constants.erb
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new("id" => nil, "guide_id" => nil, "address" => nil, "city" => nil, "state" => nil, "lat" => nil, "lng" => nil, "west" => nil, "east" => nil, "north" => nil, "south" => nil, "created_at" => nil, "updated_at" => nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Fixnum, guide_id: Fixnum, address: String, city: String, state: String, lat: BigDecimal, lng: BigDecimal, west: BigDecimal, east: BigDecimal, north: BigDecimal, south: BigDecimal, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { guide: nil, audits: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Guide" => { belongs_to: [:guide] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] } }.merge(super)
    end

    def mocked_class
      "Location"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= (["id", "guide_id", "address", "city", "state", "lat", "lng", "west", "east", "north", "south", "created_at", "updated_at"] | super)
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "locations" || super
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

  def address
    read_attribute(:address)
  end

  def address=(val)
    write_attribute(:address, val)
  end

  def city
    read_attribute(:city)
  end

  def city=(val)
    write_attribute(:city, val)
  end

  def state
    read_attribute(:state)
  end

  def state=(val)
    write_attribute(:state, val)
  end

  def lat
    read_attribute(:lat)
  end

  def lat=(val)
    write_attribute(:lat, val)
  end

  def lng
    read_attribute(:lng)
  end

  def lng=(val)
    write_attribute(:lng, val)
  end

  def west
    read_attribute(:west)
  end

  def west=(val)
    write_attribute(:west, val)
  end

  def east
    read_attribute(:east)
  end

  def east=(val)
    write_attribute(:east, val)
  end

  def north
    read_attribute(:north)
  end

  def north=(val)
    write_attribute(:north, val)
  end

  def south
    read_attribute(:south)
  end

  def south=(val)
    write_attribute(:south, val)
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

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(LocationMock::Scopes)
  end

  def self.__new_relation__(collection)
    LocationMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

end