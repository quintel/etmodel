# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets..
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w[
  admin.css
  compare.js
  establishment_shot.js
  establishment_shot_print.css
  etm.js
  energy_mix.js
  form_only.css
  i18n.js
  i18n/en.js
  i18n/nl.js
  ie.css
  multi_year_charts.css
  report.css
  pico.css
  pico.js
]

# Compile images in vendor/assets/images
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
