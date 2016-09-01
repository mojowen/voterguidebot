Fabricator(:answer) do
  question { Fabricate :question }
  candidate { Fabricate :candidate }
  text { %w(Yes No Maybe) }
end
