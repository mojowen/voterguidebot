require_relative Rails.root.join('lib', 'static_renderer')

namespace :render do
  desc "Render an HTML pages."
  task :file, [:file, :layout, :not_preview] => [:environment] do |_, args|
    filename = File.basename(args.file).split('.').first
    params = { preview: !args.has_key?(:not_preview) }
    StaticRenderer.render_file("public/avg/#{filename}.html", args.file, params, args.layout)
  end

  desc "Render a some sub pages."
  task :subpages, [:not_preview] do |_, args|
    layout = 'layouts/avg.html.haml'
    Dir.glob("app/views/templates/avg/subpages/*.html.haml").each do |path|
      Rake::Task['render:file'].invoke(path, layout, args.not_preview)
      Rake::Task['render:file'].reenable
    end
  end

  desc "Render the national page and assets."
  task :assets => [:environment] do |_, args|
    Publisher::AVG.assets_only
  end

  desc "Que all the avg guides for rendering."
  task :all => [:environment] do |_, args|
    Guide.where(template_name: [:national, :state]).each(&:start_publishing)
  end
end
