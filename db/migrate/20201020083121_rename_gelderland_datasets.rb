class RenameGelderlandDatasets < ActiveRecord::Migration[5.2]
  NAMES = {
    om_aalten: :GM0197_aalten,
    om_achterhoek: :RES01_achterhoek,
    om_apeldoorn: :GM0200_apeldoorn,
    om_arnhem: :GM0202_arnhem,
    om_barneveld: :GM0203_barneveld,
    "om_berg-en-dal": :GM1945_berg_en_dal,
    om_berkelland: :GM1859_berkelland,
    om_beuningen: :GM0209_beuningen,
    om_bronckhorst: :GM1876_bronckhorst,
    om_brummen: :GM0213_brummen,
    om_buren: :GM0214_buren,
    "om_cleantech-regio": :RES26_cleantechregio,
    om_culemborg: :GM0216_culemborg,
    om_deventer: :GM0150_deventer,
    om_doesburg: :GM0221_doesburg,
    om_doetinchem: :GM0222_doetinchem,
    om_druten: :GM0225_druten,
    om_duiven: :GM0226_duiven,
    om_ede: :GM0228_ede,
    om_elburg: :GM0230_elburg,
    om_epe: :GM0232_epe,
    om_ermelo: :GM0233_ermelo,
    om_foodvalley: :RES05_foodvalley,
    om_gelderland: :PV25_gelderland,
    om_harderwijk: :GM0243_harderwijk,
    om_hattem: :GM0244_hattem,
    om_heerde: :GM0246_heerde,
    om_heumen: :GM0252_heumen,
    om_lingewaard: :GM1705_lingewaard,
    om_lochem: :GM0262_lochem,
    om_maasdriel: :GM0263_maasdriel,
    om_montferland: :GM1955_montferland,
    "om_neder-betuwe": :GM1740_neder_betuwe,
    om_nijkerk: :GM0267_nijkerk,
    om_nijmegen: :GM0268_nijmegen,
    "om_noord-veluwe": :RES18_noord_veluwe,
    om_nunspeet: :GM0302_nunspeet,
    om_oldebroek: :GM0269_oldebroek,
    "om_oost-gelre": :GM1586_oost_gelre,
    "om_oude-ijsselstreek": :GM1509_oude_ijsselstreek,
    om_overbetuwe: :GM1734_overbetuwe,
    om_putten: :GM0273_putten,
    "om_regio_arnhem-nijmegen": :RES23_arnhem_nijmegen,
    om_renkum: :GM0274_renkum,
    om_renswoude: :GM0339_renswoude,
    om_rheden: :GM0275_rheden,
    om_rhenen: :GM0340_rhenen,
    om_rivierenland: :RES25_rivierenland_fruitdelta,
    om_rozendaal: :GM0277_rozendaal,
    om_scherpenzeel: :GM0279_scherpenzeel,
    om_tiel: :GM0281_tiel,
    om_veenendaal: :GM0345_veenendaal,
    om_voorst: :GM0285_voorst,
    om_wageningen: :GM0289_wageningen,
    "om_west-maas-en-waal": :GM0668_west_maas_en_waal,
    om_westervoort: :GM0293_westervoort,
    om_wijchen: :GM0296_wijchen,
    om_winterswijk: :GM0294_winterswijk,
    om_zaltbommel: :GM0297_zaltbommel,
    om_zevenaar: :GM0299_zevenaar,
    om_zutphen: :GM0301_zutphen,
  }.freeze

  def up
    change_names(NAMES)
  end

  def down
    change_names(NAMES.invert)
  end

  private

  def change_names(names)
    NAMES.each do |old_name, new_name|
      say_with_time "#{old_name} -> #{new_name}" do
        SavedScenario.where(area_code: old_name).update_all(area_code: new_name)
      end
    end
  end
end
