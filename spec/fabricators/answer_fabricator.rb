Fabricator(:answer) do
  question { Fabricate :question }
  candidate { Fabricate :candidate }
  text { 'Maybe' }
end
