var SliderInput = EventDispatcher.extend({
  init:function(sliderVO) {
    this.sliderVO = sliderVO;
    this.element = $('<div></div>');
    this.element.addClass('slider-input');
    this.element.attr('title', 'Click to edit this value.');
    
    this.value_element = $('<div>').addClass('value');
    this.edit_element = $('<div>').addClass('edit');
    this.element.append(this.value_element);
    this.element.append(this.edit_element);
    this.value_element.bind('click', jQuery.proxy(this.handleStartEdit, this));
    this.edit_element.bind('click', jQuery.proxy(this.handleStartEdit, this));
    this.edit_element.hide();
    
    
    
    // edit element
    
    this.edit_form_element = $('<form>').addClass('edit-value');
    this.input_element = $('<input type="text">');
    this.cancel_element = $('<input type="button" value="Cancel">');
    this.cancel_element.bind('click', jQuery.proxy(this.handleCancelEdit, this));
    this.ok_button = $('<input type="submit" value="OK">');
    this.ok_button.bind('click', jQuery.proxy(this.handleFinishedEdit, this))
    this.edit_form_element.bind('submit', jQuery.proxy(this.handleFinishedEdit, this))
    
    
    this.edit_form_element.append(this.input_element);
    this.edit_form_element.append(this.ok_button);
    //this.edit_form_element.append(this.cancel_element);
    this.edit_element.hide();

    this.edit_form_element.hide();
    this.element.append(this.edit_form_element);
    
    
    this.sliderVO.addEventListener('update', jQuery.proxy(this.handleUpdate, this));
    this.draw();
  },
  
  handleUpdate:function(e) {
    this.draw();
  },
  draw:function() {
    this.value_element.html(this.sliderVO.getFormattedValue());
    this.input_element.attr('value', this.sliderVO.getRoundedValue());
  },
  mouseOver:function() {
    //this.edit_element.show();
  },
  mouseOut:function() {
    //this.edit_element.hide();
  },
  
  /**
   * If edit is clicked the input element, will be a text edit.
   */
  handleStartEdit:function() {
    if(this.sliderVO.isDisabled()) {
      return false;
    }
    this.value_element.hide();
    //this.edit_element.hide();
    this.edit_form_element.show();
    this.firstClick = true;
    $(document).bind('click', jQuery.proxy(this.handleCancelEdit, this));
  },
  
  handleCancelEdit:function(e) {
    var lParents = $(e.target).parents();
    for(var i = 0; i < lParents.length; i++) {
      // console.info(lParents[i])
      if(lParents[i] == this.element[0])
        return;
    }
    
    this.draw()
    this.value_element.show();
    //this.edit_element.show();
    this.edit_form_element.hide();
    $(document).unbind('click', jQuery.proxy(this.handleCancelEdit, this));
  },
  handleFinishedEdit:function() {
    this.sliderVO.setValue(this.input_element.attr('value'));
    this.dispatchEvent('update');
    this.value_element.show();
    this.edit_form_element.hide();
    this.edit_element.hide();
    $(document).unbind('click', jQuery.proxy(this.handleCancelEdit, this));
    return false; // needed for form
  }
  
})