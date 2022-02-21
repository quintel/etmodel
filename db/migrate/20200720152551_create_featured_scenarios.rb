# frozen_string_literal

# Adds featured_scenarios stable, and created saved scenarios based on the current ETEngine presets.
class CreateFeaturedScenarios < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do
      create_table :featured_scenarios do |t|
        t.integer :saved_scenario_id, null: false
        t.string :group
        t.string :title_en, null: false
        t.string :title_nl, null: false
        t.text :description_en
        t.text :description_nl
        t.index :saved_scenario_id, unique: true
      end

      reversible do |dir|
        dir.up do
          add_foreign_key :featured_scenarios, :saved_scenarios
          create_featured_scenarios(create_user)
        end

        dir.down do
          SavedScenario.where(id: FeaturedScenario.pluck(:saved_scenario_id)).each do |ss|
            UnprotectApiScenario.call(ss.scenario_id)
            ss.destroy!
          end
        end
      end
    end
  end

  private

  def create_user
    user = User.find_by_email('info@energytransitionmodel.com')
    return user if user.present?

    password = SecureRandom.alphanumeric
    role = Role.find_by_name('admin')

    user = User.create!(
      email: 'info@energytransitionmodel.com',
      name: 'Energy Transition Model',
      role: role,
      password: password,
      password_confirmation: password
    )

    say "Created admin info@ user with password: #{password}"

    user
  end

  def create_featured_scenarios(user)
    Api::Scenario.all(from: :templates).each do |preset|
      create_featured_scenario(preset, user)
    end
  end

  def create_featured_scenario(preset, user)
    saved_scenario = CreateSavedScenario
      .call(preset.id, user, title: preset.title, description: preset.description)
      .unwrap("Failed to create scenario #{preset.id} #{preset.title}")

    say "Created #{preset.title}"

    # Prevents the ETEngine scenarios from referencing presets which will soon no longer exist.
    saved_scenario.scenario.update_attributes(preset_scenario_id: nil)

    document = Nokogiri::HTML.parse(preset.description)
    en_desc = document.at('.en')&.inner_html&.strip || preset.description.strip
    nl_desc = document.at('.nl')&.inner_html&.strip || preset.description.strip

    FeaturedScenario.create!(
      saved_scenario: saved_scenario,
      group: etengine_to_etmodel_group(preset.display_group),
      title_en: preset.title,
      title_nl: preset.title,
      description_en: en_desc,
      description_nl: nl_desc
    )
  end

  def etengine_to_etmodel_group(group_name)
    case group_name.to_s
    when /national/i then 'national'
    when /region/i   then 'regional'
    when /muni/i     then 'municipal'
    end
  end
end
