require 'rails_helper'

RSpec.describe StaticRenderer do
  describe '#render_html' do
    it 'renders a view' do
      file = Rails.root.join(*%w(spec fixtures test.html.erb))
      expect(described_class.render_html(file, { preview: false })).to include('4')
    end

    it 'renders a view with a layout'  do
      file = Rails.root.join(*%w(spec fixtures test.html.erb))
      expect(described_class.render_html(file, { preview: false }, 'layouts/avg.html.haml')).to include('<html>')
    end

    it 'renders a view with params' do
      file = Rails.root.join(*%w(spec fixtures test.html.haml))
      expect(described_class.render_html(file, { banana: 'fig' })).to include('fig')
    end
  end

  describe '#render_file' do
    it 'creates a file' do
      file = Rails.root.join(*%w(spec fixtures test.html.erb))
      rendered_file = Rails.root.join(*%w(spec test_files rendered.html))
      described_class.render_file(rendered_file, file, { preview: false }, 'layouts/avg.html.haml')
      file_content = File.read(rendered_file)

      expect(file_content).to include('<html>')
      expect(file_content).to include('4')
    end
  end
end
