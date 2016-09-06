module Publisher
  class National < AVG

    def resource
      "http://#{bucket}"
    end

    def self.assets_only
      new(Guide.new).collect_and_sync_assets
    end

    def collect_and_sync_assets
      collect_assets
      sync_assets
    end

    private

    def generate
      render_index
      collect_and_sync_assets
    end

    def render_index
      render_static 'index.html'
    end

    def collect_assets
      render_assets

      move_files Rails.root.join(*%w{public assets avg*.*}), asset_path
      move_files Rails.root.join(*%w{public assets avg *.*}), asset_path
      make_subpages Rails.root.join(*%w{public avg *.html})
    end

    def move_files(files, dest)
      Dir[files].each do |file|
        filename = File.basename(file)
        next if filename.include? '.gz'
        FileUtils.cp file, Rails.root.join(dest, filename.gsub(/\-.+\./, '.'))
      end
    end

    def make_subpages(subpages)
      Dir[subpages].each do |subpage|
        filename = File.basename(subpage)
        return move_files(subpage) if !filename.include?('.html') || filename.include?('index')
        dir_path = Rails.root.join(root_path, filename.split('.html').first)
        FileUtils.mkdir dir_path
        FileUtils.cp subpage, Rails.root.join(dir_path, 'index.html')
      end
    end

    def render_assets
      `bundle exec rake assets:precompile` if Rails.env.development?
      `bundle exec rake render:subpages[true]`
    end
  end
end
