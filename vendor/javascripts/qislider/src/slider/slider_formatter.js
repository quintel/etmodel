var SliderFormatter = {

  format: function(n, symbol) { 
        
    // precision = precision == null ? 2 : precision;
    symbol = symbol == null ? "%" : symbol;
    out = n + " " +  symbol;
    return out;
    
  },
  
  
  
  /**
   * Return a function that displays the page  with a specific precision
   */
  roundingFactory: function(precision, symbol) {
  
    return $.proxy(function(n) {
      return this.format(n, precision, symbol);
    }, this);
  },
  
  /**
   * Return a function that displays the page  with a specific precision
   */
  numberWithSymbolFactory: function(symbol) {
  
    return $.proxy(function(n) {
      return this.format(n, symbol);
    }, this);
  }
  
}