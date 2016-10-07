module Publisher
  class AVG < Base

    def initialize(guide)
      super(guide)
    end

    def self.assets_only
      new(Guide.new).collect_and_sync_assets
    end

    def collect_and_sync_assets
      FileUtils.mkdir_p asset_path
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
      `bundle exec rake assets:clobber`
      `RAILS_ENV=production SECRET=what bundle exec rake assets:precompile`
      `bundle exec rake render:subpages[true]`
    end

    def render_static(rel_path_to_file, layout: nil)
      StaticRenderer.render_file Rails.root.join(root_path, rel_path_to_file),
                                 template.template_file_path(template.view),
                                 { guide: guide, preview: false },
                                 'layouts/avg.html.haml'
    end

    def render_image(filename, view, params)
      html_file = Rails.root.join(root_path, "#{filename}.html")
      png_file = Rails.root.join(root_path, "#{filename}.png")

      StaticRenderer.render_file html_file,
                                 template.template_file_path(view),
                                 params.update(preview: false),
                                 'layouts/avg_img.html.haml'

      phantom = PhantomRenderer.new html_file, extension: :png
      phantom.render path: png_file, width: '1200px', height: '630px'
      FileUtils.rm_r html_file
    end

    def render_redirect(html_file, view, params)
      StaticRenderer.render_file html_file,
                                 template.template_file_path(view),
                                 params.update(preview: false),
                                 'layouts/avg_redirect.html.haml'
    end

    def render_social(html_file, view, params)
      render_image html_file, view, params
      render_redirect "#{html_file}.html", view, params.update(redirect_url: resource)
    end

    def render_contests
      guide.contests.each { |contest| render_contest(contest) }
    end

    def render_measures
      FileUtils.mkdir_p measures_path

      guide.measures.each do |measure|
        render_social(
          Rails.root.join(measures_path, "#{measure.id}-#{measure.slug}"),
          "measure_info",
          measure: measure, anchor: "measure_#{measure.id}"
        )
      end
    end

    def render_contest(contest)
      contest_path = Rails.root.join contests_path, contest.id.to_s
      FileUtils.mkdir_p contest_path

      StaticRenderer.render_file Rails.root.join(contest_path, 'index.html'),
                                 'templates/avg/embed',
                                 { contest: contest, preview: false }

      render_social(
        Rails.root.join(contest_path, "info"),
        "contest_info",
        contest: contest, anchor: "contest_#{contest.id}"
      )

      contest.questions.each.with_index do |question, index|
        render_social(
          Rails.root.join(contest_path, "#{question.slug}"),
          "contest_question",
          question: question, anchor: "contest_#{contest.id}_#{index+1}"
        )

        contest.candidates.each do |candidate|
          render_social(
            Rails.root.join(contest_path, "#{question.slug}-#{candidate.slug}"),
            "candidate_question",
            candidate: candidate, question: question, anchor: "contest_#{contest.id}_#{index+1}"
          )
        end
      end

      contest.candidates.each do |candidate|
        render_social(
          Rails.root.join(contest_path, candidate.slug),
          "candidate_info",
          candidate: candidate, anchor: "contest_#{contest.id}"
        )
      end
    end

    def sync_assets
      s3.upload_directory root_path
    end

    def clean_assets
      FileUtils.rm_r base_path
    end

    def s3
      @s3_uploader ||= S3Wrapper.new bucket
    end

    def bucket
      ENV['AVG_BUCKET'] || 'preview.americanvoterguide.org'
    end

    def base_path
      @base_path ||= Rails.root.join('tmp', 'renders', Time.now.getutc.to_i.to_s)
    end

    def root_path
      Rails.root.join(base_path, 'avg')
    end

    def asset_path
      Rails.root.join(root_path, 'assets')
    end

    def contests_path
      Rails.root.join(root_path, 'contests')
    end

    def measures_path
      Rails.root.join(root_path, 'measures')
    end

    def clean
      clean_assets
    end
  end
end
