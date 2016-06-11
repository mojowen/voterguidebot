Fabricator(:guide) do
  name { 'My Great Guide' }
  location { Fabricate :location }
  election_date { '11/8/2016' }
end
