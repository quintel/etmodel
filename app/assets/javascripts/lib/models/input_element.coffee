class @InputElement extends Backbone.Model
  initialize: ->
    @dirty = false
    @ui_options =
      element: $("#input_element_#{@get('id')}")
    @bind('change:user_value', @markDirty)
    @bind('change:user_value', @logUpdate)
    @bind('change:user_value', @update_collection)

  set_min_value: (result) =>
    @set({'min_value' : result})

  set_max_value: (result) =>
    @set({'max_value' : result})

  set_label: (label) =>
    return unless _.isObject(label)
    @set({'label' : label})

  set_start_value: (result) =>
    @set({'start_value' : result})

  init_legacy_controller: =>
    if @already_init != true
      App.input_elements.addInputElement(this)
      @already_init = true

  logUpdate: =>
    percent = 100 -
      ((@get('max_value') - @get('user_value')) /
      ((@get('max_value') - @get('min_value')) / 100))
    percent = Math.round percent
    App.debug "Moved slider #{@get 'key'} percent: #{percent}"
    Tracker.event_track('Slider','Changed', @get('key'), percent)
    Tracker.track
      slider: @get('translated_name')
      new_value: @get('user_value')

  # if we're caching the user_values hash then we have to store locally the
  # user_values, without querying the engine
  update_collection: =>
    App.input_elements.user_values[@get('key')]['user_value'] = @get('user_value')

  # Returns if this is dirty, meaning a attribute has changed.
  isDirty: => if @get('fixed') == true then false else @dirty

  markDirty: => @dirty = true

  setDirty: (dirty) => @dirty = dirty

class @InputElementList extends Backbone.Collection
  model: InputElement

  initialize: ->
    @inputElements     = {}
    @inputElementViews = {}
    @shareGroups = {}
    @balancers   = {}
    for s in $(".slider")
      @add $(s).data('attrs')

  init_legacy_controller: =>
    @each (input_element) -> input_element.init_legacy_controller()

  initialize_user_values: (data) =>
    @user_values = data
    @setup_input_elements()

  setup_input_elements: =>
    user_values = @user_values
    @each (i) ->
      values = user_values[i.get('key')];
      if !values
        console.warn "Missing slider information! #{i.get 'key'}"
        return false;
      i.set_min_value(values.min)
      i.set_max_value(values.max)
      i.set_start_value(values.default)
      i.set_label(values.label)

      v = +values.user
      def = if (v? && !_.isNaN(v)) then v else values.default

      i.set({
        user_value: def
        # Disable if ET-Model *or* ET-Engine disable the input.
        disabled: i.get('disabled') || values.disabled
      }, { silent: true })

      i.init_legacy_controller()

  # Get the string which contains the update values for all dirty input elements
  api_update_params: =>
    out = {}
    for s in @dirty()
      out[s.get 'key'] = s.get 'user_value'
    out

  dirty: =>
    @select (el) -> el.isDirty()

  reset_dirty: =>
    _.each(@dirty(), (el) -> el.setDirty(false))

  # Add a constraint to the constraints.
  # @param options - must contain an element item
  addInputElement: (inputElement, options) =>
    options = inputElement.ui_options
    @inputElements[inputElement.id] = inputElement
    view = new InputElementView({model : inputElement, el : options.element})
    @inputElementViews[inputElement.id] = view
    view.bind "change", @handleUpdate
    true

  # Initialize a share group for an input element if it has one.
  initShareGroup: (inputElement) =>
    inputElementView = @inputElementViews[inputElement.id]
    shareGroupKey = inputElement.get("share_group")
    if shareGroupKey && shareGroupKey.length
      shareGroup = @getOrCreateShareGroup(shareGroupKey)
      shareGroup.bind "slider_updated", inputElement.markDirty
      # set all sliders from same sharegroup to dirty when one is touched
      shareGroup.addSlider(inputElementView.sliderView.sliderVO)

      balancer = @getOrCreateBalancer(shareGroupKey)
      balancer.add(inputElementView)

  # Finds or creates the share group.
  getOrCreateShareGroup: (shareGroup) =>
    if(!@shareGroups[shareGroup])
      @shareGroups[shareGroup] = new SliderGroup({'total_value':100})
      # add group if not created yet
    @shareGroups[shareGroup]

  getOrCreateBalancer: (name) =>
    if !@balancers.hasOwnProperty(name)
      @balancers[name] = new InputElementGroup({ max: 100 })
    @balancers[name]

  # Does a update request to update the values.
  handleUpdate: => @trigger("change")
