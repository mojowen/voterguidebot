Fabricator(:guide) do
  name { 'My Great Guide' }
  location { Fabricate :location }
end
