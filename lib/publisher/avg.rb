module Publisher
  class AVG < Base

    def initialize(guide)
      super(guide)
      FileUtils.mkdir_p asset_path
    end

    def self.assets_only
      new(Guide.new).collect_and_sync_assets
    end

    def collect_and_sync_assets
      collect_assets
      sync_assets
      clean_assets
    end

    private

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
      `bundle exec rake assets:clean`
      `RAILS_ENV=production SECRET=what bundle exec rake assets:precompile`
      `bundle exec rake render:subpages[true]`
    end

    def render_static(rel_path_to_file)
      StaticRenderer.render_file Rails.root.join(root_path, rel_path_to_file),
                                 template.template_file_path(template.view),
                                 { guide: guide, preview: false },
                                 'layouts/avg.html.haml'
    end

    def render_contests
      guide.contests.each { |contest| render_contest(contest) }
    end

    def render_contest(contest)
      contest_path = Rails.root.join contests_path, contest.id.to_s
      FileUtils.mkdir_p contest_path

      StaticRenderer.render_file Rails.root.join(contest_path, 'index.html'),
                                 'templates/avg/embed',
                                 { contest: contest, preview: false }
    end

    def sync_assets
      s3.upload_directory root_path
    end

    def clean_assets
      FileUtils.remove_dir root_path
    end

    def s3
      @s3_uploader ||= S3Wrapper.new bucket
    end

    def bucket
      ENV['AVG_BUCKET'] || 'preview.americanvoterguide.org'
    end

    def root_path
      @root_path ||= Rails.root.join('tmp', 'renders', Time.now.getutc.to_i.to_s, 'avg')
    end

    def asset_path
      @asset_path ||= Rails.root.join(root_path, 'assets')
    end

    def contests_path
      @contests_path ||= Rails.root.join(root_path, 'contests')
    end

    def clean
      clean_assets
    end
  end
end
