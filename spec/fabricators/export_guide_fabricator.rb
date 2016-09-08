Fabricator(:export_guide) do
  guide { Fabricate :guide }
  export { Fabricate :export }
end
