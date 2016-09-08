Fabricator(:export) do
  user { Fabricate :user }
  before_save { |export| export.guides << Fabricate(:guide) if export.guides.empty? }
end
