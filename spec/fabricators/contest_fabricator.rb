Fabricator(:contest) do
  guide { Fabricate :guide }
  title { 'Mayor of Gotham' }
  description { 'Thanks to the bat' }
end
