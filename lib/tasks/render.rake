require_relative Rails.root.join('lib', 'static_renderer')

namespace :render do
  desc "Render an HTML pages."
  task :file, [:path, :layout] => [:environment] do |_, args|
    filename_and_path = args.path.split('.').first
    filename = filename_and_path.split('/').last
    StaticRender.render_file("avg/#{filename}", filename_and_path, {}, args.layout)
  end

  desc "Render a some sub pages."
  task :subpages, :paths do |_, args|
    layout = 'layouts/avg.html.haml'
    args.paths.each do |path|
      Rake::Task['render:file'].invoke(path, layout)
      Rake::Task['render:file'].reenable
    end
  end

  namespace :subpages do
    desc "Renders all subpages"
    task :all do
      Rake::Task['render:subpages'].invoke(Dir.glob("app/views/templates/avg/subpages/*.html.haml"))
      Rake::Task['render:subpages'].reenable
    end
  end
end
