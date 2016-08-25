class Template < OpenStruct
  def initialize(template_name)
    @template_name = template_name
    super config_file(template_name)
  end

  def as_json
    to_h.as_json
  end

  def render
    { template: template_file_path(view), layout: layout }
  end

  def template_file_path(file)
    return unless file
    File.join('templates', folder || template_name, file)
  end

  def self.default
    new(:default)
  end

  private

  attr_reader :template_name

  def config_file(name, inheritable = true)
    config = YAML.load_file Rails.root.join('config', 'templates', "#{name}.yml")
    return config unless config['inherits'] && inheritable
    config_file(config['inherits'], false).merge(config)
  end
end
