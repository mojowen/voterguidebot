class Template < OpenStruct
  def initialize(template_name)
    @template_name = template_name
    super config_file(template_name)
  end

  def as_json(**kwargs)
    to_h.as_json(kwargs)
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

  class << self
    def web_templates
      all_templates
        .select { |tf| YAML.load_file(tf)['publisher_type'] == 'web' }
        .map { |tf| tf.split(template_path.to_s).last.split('.').first.sub('/', '') }
    end

    def template_path
      Rails.root.join('config', 'templates')
    end

    private

    def all_templates
      @all_templates ||= Dir.glob(Rails.root.join(template_path, '**/*.yml'))
    end
  end

  private

  attr_reader :template_name

  def config_file(name, inheritable = true)
    return {} unless File.exist? template_file(name)
    config = YAML.load_file template_file(name)
    return config unless config['inherits'] && inheritable
    config_file(config['inherits'], false).merge(config)
  end

  def template_file(name)
    Rails.root.join(self.class.template_path, "#{name}.yml")
  end
end
