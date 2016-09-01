Fabricator(:guide) do
  name { 'My Great Guide' }
  location { Fabricate :location }
  election_date { '11/8/2016' }
  template_name :default
end

Fabricator(:full_guide, from: :guide) do
  contests(rand: 5) { Fabricate :full_contest }
  measures(rand: 5) { Fabricate :measure }
  before_create do |guide|
    guide.template_fields = Hash[guide.template_fields.map do |field|
      [field['name'], "#{field['name']} value"]
    end]
  end
end
