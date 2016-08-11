class Template < OpenStruct
  def initialize(template_name)
    super config_file(template_name)
  end

  def as_json
    to_h.as_json
  end

  def render
    { template: File.join('templates', view), layout: File.join('..', 'templates', layout) }
  end

  def self.default
    new(:default)
  end

  private

  def config_file(name, inheritable = true)
    config = YAML.load_file Rails.root.join('config', 'templates', "#{name}.yml")
    return config unless config['inherits'] && inheritable
    config_file(config['inherits'], false).merge(config)
  end
end
