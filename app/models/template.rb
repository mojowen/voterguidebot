class Template < OpenStruct
  def self.default
    @default ||= new YAML.load_file(Rails.root.join('config','template.yml'))
  end

  def as_json
    to_h.as_json
  end
end
