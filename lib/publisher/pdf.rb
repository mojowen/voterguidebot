module Publisher
  class PDF < Base
    def html
      StaticRenderer.render_file guide_html_file,
                                 template.template_file_path(template.view),
                                 { guide: guide, preview: false }
    end

    def pdf
      phantom = PhantomRenderer.new guide_html_file, extension: :pdf
      phantom.render height: template.size['height'], width: template.size['width']
      phantom
    end

    private

    def generate
      html
      pdf.upload key: "#{guide.slug}/#{template.publisher_resource}"
    end

    def clean
      File.delete guide_html_file if File.exists? guide_html_file
      File.delete guide_pdf_file if File.exists? guide_pdf_file
    end

    def guide_html_file
      Rails.root.join('tmp', "#{guide.slug}.html")
    end

    def guide_pdf_file
      Rails.root.join('tmp', "#{guide.slug}.pdf")
    end
  end
end
