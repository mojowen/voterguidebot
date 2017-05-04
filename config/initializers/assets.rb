
Rails.application.config.assets.version = '1.0'

def get_file_names(path, extension)
  assets_base = Rails.root.join('app', 'assets')
  Dir.glob(File.join(assets_base, path, ".#{extension}*")).map do |file|
    "#{file.split('/').last.split('.').first}.#{extension}"
  end.reject { |file| file == 'applicattion' }
end


Rails.application.config.assets.precompile += get_file_names("javascripts", "js")
Rails.application.config.assets.precompile += get_file_names("stylesheets", "css")
