# frozen_string_literal: true

require 'yaml'

desc 'Move descriptions from interface ymls to I18n files.'
task move_descriptions: :environment do
  include LocalizeDescriptions

  model = ENV['model']

  raise ArgumentError, "You should specify which `model`" unless model

  interface_path = Rails.root.join('config', 'ymodel', model + '.yml')

  en_descriptions = {}
  nl_descriptions = {}

  interface_yml = YAML.load_file(interface_path)
  interface_yml.each do |item, empty|
    next unless item && item['description']
    en_descriptions[item['key']] = build_description('en', item['description'])
    nl_descriptions[item['key']] = build_description('nl', item['description'])

    item.except!('description')
  end

  write_to_locale(model, 'en', en_descriptions)
  write_to_locale(model, 'nl', nl_descriptions)
  File.write(interface_path, interface_yml.to_yaml)
end

module LocalizeDescriptions
  require 'yaml'

  def build_description(language, description)
    { 'short_content' => description[('short_content_' + language)],
      'content' => description[('content_' + language)] }
  end

  def write_to_locale(model_name, language, descriptions_hash)
    file_name = language + '_descriptions_' + model_name + '.yml'
    path = Rails.root.join( 'config', 'locales', file_name)
    File.write(
      path,
      { language => { "descriptions_#{model_name}" => descriptions_hash } }
        .to_yaml
    )
  end
end
