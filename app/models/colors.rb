module Colors
  COLORS = {
      'gas_grey' => '#CCCCCC',
      'wind_blue' => '#63A1C9',
      'water_blue' => '#416B86',
      'cooling_blue' => '#BFEFFF',
      'lignite_grey' => '#666666',
      'coal_black' => '#333333',
      'oil_brown' => '#854321',
      'nuclear_orange' => '#E07033',
      'geothermal_brown' => '#BA7D40',
      'durable_green' => '#ADDE4C',
      'cofiring_green' => '#92B940',
      'biomass_green' => '#5D7929',
      'waste_green' => '#394C19',
      'green' => '#92B940',
      'lightgreen' => '#B3CF7B',
      'lightgrey' => '#CCCCCC',
      'darkgrey' => '#484848',
      'blue' => '#51A0BF',
      'darkred' => '#6B2602',
      'orange' => '#DD7135',
      'lightorange' => '#E69567',
      'yellow' =>'#FFD700',
      'skyblue' =>'#87CEEB',      
      'red' => '#FF0000',      
      'purple' =>'#800080',
      'pink' =>'#D87093',
      'orange' =>'#FFA500',    
      'limegreen' =>'#32CD32',    
      'lightgreen' =>'#90EE90',
      'lightblue' =>'#ADD8E6',  
      'grey' =>'#A9A9A9',
      'green' =>'#228B22',
      'darkred' =>'#8B0000',
      'darkgrey' =>'#696969',
      'darkgreen' =>'#006400',        
      'darkblue' =>'#00008B',
      'brown' =>'#8B4513',        
      'blue' =>'#4169E1',
      'black' =>'#000000'
  }

  def convert_color(color_name)
    COLORS[color_name.downcase] || color_name
  end

end
