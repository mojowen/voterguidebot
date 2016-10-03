require 'phantomjs'

class PhantomRenderer
  attr_accessor :path_to_file, :extension, :rendered_filepath

  def initialize(path_to_file, extension: nil)
    @path_to_file = path_to_file
    @extension = extension || :pdf
  end

  def render(path: nil, **render_kwargs)
    @rendered_filepath = path || tmp_filepath
    phantom command(**render_kwargs)
    self
  end

  def upload(bucket: nil, key: nil)
    S3Wrapper.new(bucket).upload_file_if_changed(rendered_filepath, key)
  end

  def self.render_and_upload(path_to_file, **kwargs)
    new(path_to_file, extension: kwargs[:extension])
      .render(height: kwargs[:height], width: kwargs[:width])
      .upload(bucket: kwargs[:bucket], key: kwargs[:key])
  end

  private

  def phantom(command)
    phantom = `#{Phantomjs.path} #{command}`
    raise "Could not render #{rendered_filepath} #{phantom}" if $?.exitstatus != 0
  end

  def command(height: nil, width: nil, margin: 0)
    [render_script, path_to_file, rendered_filepath, width, height, margin].join(' ')
  end

  def tmp_filepath
    Rails.root.join('tmp', rendered_filename)
  end

  def rendered_filename
    "#{file_name}.#{extension}"
  end

  def file_name
    File.basename(path_to_file).split('.').first
  end

  def render_script
    Rails.root.join(*%w(lib tasks render.js)).to_s
  end
end
