# YModel

This is a piece of code used migrate the old static records from ETModel to
Config files.

Current goals are:
  - Providing an AR like interface so its easy to replace the old AR model
  - Being able to interoperate with existing AR objects.

## The old Schema

Models:
  - Constraint
  - Description
  - InputElement
  - OutputElement
  - SidebarItem
  - Slide
  - Tab
  - Target
  - OutputElementSerie
  - OutputElementType
  - AreaDependency
  - Target
  - Text


## Plan of attack:

We've decided its best to chop the work into chunks.


WUT IS THIS?
  - OutputElementSerie
  - OutputElementType
  - AreaDependency
  - Text
  - Constraint
  - SidebarItem
  - Target

Some models can stay more or less the same.
  - Tab
  - Slide
  - InputElement
  - OutputElement

Some models can be deleted.
  - Target

Some models could be implemented in a different way.
  - Description


create_table "area_dependencies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
  t.string "dependent_on"
  t.text "description"
  t.integer "dependable_id"
  t.string "dependable_type", limit: 191
  t.index ["dependable_id", "dependable_type"], name: "index_area_dependencies_on_dependable_id_and_dependable_type"
end
