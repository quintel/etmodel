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


## Roadmap:


#### First stage
- Build a library that enables us to wrap a yaml file with a simple AR-like API implementing methods such as find, where and the simple relations.
- Build a script that dumps a record to YAML.
- Migrate Tabs and Sidebar items to YModel.

#### Second stage
- Convert all "Semi-static data models" to YModel.

## What models do we want to migrate?

#### These models have been migrated
- Tab
- SidebarItem

#### These models need to be migrated but seem simple to tackle:
- Slide
- InputElement
- OutputElement

#### These models need to be migrated but seem simple to tackle:
- OutputElementSerie
- OutputElementType
- AreaDependency
- Text
- Constraint
- Target


#### These models can be deleted
  - Target

#### These models should be implemented in a different way.
  - Description
