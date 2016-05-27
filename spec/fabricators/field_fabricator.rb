Fabricator(:field) do
  guide { Fabricate :guide }
  field_template { 'title_page_header' }
end
