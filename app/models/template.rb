class Template
  attr_accessor :name, :fields, :contests, :candidates,
                :ballot_measures, :endorsements, :questions, :question_tags,
                :question_seeds, :screenshot

  def self.default
    @default ||= new YAML.load_file(Rails.root.join('config','template.yml'))
  end

  def initialize(attrs={})
    @name = attrs['name']
    @screenshot = attrs['screenshot']
    @fields = attrs['fields'].map(&:with_indifferent_access)
    @contests = attrs['contests']
    @candidates = attrs['candidates']
    @questions = attrs['questions']
    @endorsements = attrs['endorsements']
    @ballot_measures = attrs['ballot_measures']
    @question_tags = attrs['question_tags']
    @question_seeds = attrs['question_seeds']
  end

end
