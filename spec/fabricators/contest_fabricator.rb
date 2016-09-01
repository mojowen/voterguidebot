Fabricator(:contest) do
  guide { Fabricate :guide }
  title { 'Mayor of Gotham' }
  description { 'Thanks to the bat' }
end

Fabricator(:full_contest, from: :contest) do
  after_build do |contest|
    candidates = Fabricate.times(4, :candidate, contest: contest)
    questions = Fabricate.times(4, :question, contest: contest)
    2.times do
      Fabricate(:answer, candidate: candidates[0], question: questions[0])
      Fabricate(:answer, candidate: candidates[1], question: questions[0])
    end
  end
end
