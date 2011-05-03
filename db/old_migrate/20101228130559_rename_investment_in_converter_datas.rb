class RenameInvestmentInConverterDatas < ActiveRecord::Migration
  def self.up
    rename_column :converter_datas, :investment_excl_ccs, :investment
  end

  def self.down
    rename_column :converter_datas, :investment, :investment_excl_ccs
  end
end