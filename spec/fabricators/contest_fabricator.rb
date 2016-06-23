Fabricator(:contest) do
  guide { Fabricate :guide }
  title { 'Mayor of Gotham' }
end
