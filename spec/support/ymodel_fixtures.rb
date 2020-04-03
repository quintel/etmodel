module YmodelFixtures
  OutputElementType.source_file(
    Rails.root.join('spec', 'fixtures', 'output_element_types.yml')
  )
  OutputElement.source_file(
    Rails.root.join('spec', 'fixtures', 'output_elements.yml')
  )
  OutputElementSerie.source_file(
    Rails.root.join('spec', 'fixtures', 'output_element_series.yml')
  )
end
