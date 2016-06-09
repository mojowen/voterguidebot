class Language < ActiveRecord::Base
  audited associated_with: :guide
  belongs_to :guide

  LANGUAGES = {
    ar: 'Arabic',
    zh: 'Chinese',
    de: 'German',
    ja: 'Japanese',
    ko: 'Korean',
    es: 'Spanish',
    vi: 'Vietnamese'
  }

  def name
    LANGUAGES[code.to_sym]
  end

  def self.available_languages(guide=nil)
    taken = guide ? guide.languages.map(&:code).reject(&:nil?).map(&:to_sym) : []
    LANGUAGES.reject{ |code,_| taken.include? code }
  end

  def as_json(options = nil)
    super({ methods: [:name], only: [:code] }.update(options))
  end

  validates :code,
    uniqueness: { scope: :guide },
    presence: true,
    inclusion: LANGUAGES.keys.map(&:to_s)

end
