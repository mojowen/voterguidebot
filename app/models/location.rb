class Location < ActiveRecord::Base
  audited associated_with: :guide

  belongs_to :guide

  validates :lat, presence: true
  validates :lng, presence: true

  validates :north, presence: true
  validates :south, presence: true
  validates :east, presence: true
  validates :west, presence: true

  STATES = { AL: 'Alabama', AK: 'Alaska', AZ: 'Arizona', AR: 'Arkansas',
             CA: 'California', CO: 'Colorado', CT: 'Connecticut',
             DC: 'Washington DC', DE: 'Delaware', FL: 'Florida', GA: 'Georgia',
             HI: 'Hawaii', ID: 'Idaho', IL: 'Illinois', IN: 'Indiana',
             IA: 'Iowa', KS: 'Kansas', KY: 'Kentucky', LA: 'Louisiana',
             ME: 'Maine', MD: 'Maryland', MA: 'Massachusetts', MI: 'Michigan',
             MN: 'Minnesota', MS: 'Mississippi', MO: 'Missouri', MT: 'Montana',
             NE: 'Nebraska', NV: 'Nevada', NH: 'New Hampshire',
             NJ: 'New Jersey', NM: 'New Mexico', NY: 'New York',
             NC: 'North Carolina', ND: 'North Dakota', OH: 'Ohio',
             OK: 'Oklahoma', OR: 'Oregon', PA: 'Pennsylvania',
             RI: 'Rhode Island', SC: 'South Carolina', SD: 'South Dakota',
             TN: 'Tennessee', TX: 'Texas', UT: 'Utah', VT: 'Vermont',
             VA: 'Virginia', WA: 'Washington', WV: 'West Virginia',
             WI: 'Wisconsin', WY: 'Wyoming' }.freeze

  def state_name
    STATES[state.upcase.to_sym]
  end

  def state_slug
    return '' unless state_name
    state_name.gsub(/\s/,'').downcase
  end

  def self.to_state_abv(name)
    return '' unless name || name.length < 4
    STATES.select { |_, state| state.downcase.match(name.downcase) }.map(&:first)
  end
end
