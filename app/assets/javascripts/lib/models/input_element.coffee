class @InputElement extends Backbone.Model
  initialize: ->
    @dirty = false
    @on_screen = false
    @ui_options =
      element: $("#input_element_#{@get('id')}")
    @bind('change:user_value', @markDirty)
    @bind('change:user_value', @logUpdate)
    @bind('change:user_value', @update_collection)
    @bind('change:user_value', @additional_callbacks)

  conversions: ->
    conversions = @get('conversions') or []

    if App.settings.get_scaling() and Quantity.isSupported(@get('unit'))
      base   = new Quantity(@get('start_value'), @get('unit'))
      scaled = base.smartScale()

      if scaled.unit.name isnt base.unit.name
        conversions = conversions.slice()

        conversions.push({
          default:    true
          unit:       scaled.localizedUnit()
          multiplier: base.unit.power.multiple / scaled.unit.power.multiple
        })

    conversions

  logUpdate: =>
    App.debug "Slider #{@get 'key'}: #{@get('user_value')}"

  # if we're caching the user_values hash then we have to store locally the
  # user_values, without querying the engine
  update_collection: =>
    App.input_elements.user_values[@get('key')]['user'] = @get('user_value')

  # Returns if this is dirty, meaning a attribute has changed.
  isDirty: => if @get('fixed') == true then false else @dirty

  markDirty: => @dirty = true

  setDirty: (dirty) => @dirty = dirty

  # Extra event callbacks. We could also use an event-based strategy, ie
  # triggering, when a slider is touched, a 'slider_key:changed' event.
  #
  additional_callbacks: ->
    if @get('key') == 'settings_enable_merit_order'
      App.update_merit_order_checkbox()

class @InputElementList extends Backbone.Collection
  model: InputElement

  initialize: ->
    @inputElements     = {}
    @inputElementViews = {}
    @add $(s).data('attrs') for s in $(".slider")

  initialize_user_values: (data) =>
    @user_values = data
    @setup_input_elements()

  setup_input_elements: =>
    user_values = @user_values
    @each (i) =>
      values = user_values[i.get('key')]
      if !values
        console.warn "Missing slider information! #{i.get 'key'}"
        return false
      i.set
        min_value: values.min
        max_value: values.max
        start_value: values.default
        label: if _.isObject(values.label) then values.label else null

      if App.settings.get_scaling()
        if ! i.get('step_value') || i.get('step_value') > values.step
          # When region scaling, the pre-defined input step is too large for
          # some inputs. We therefore use the values from ETEngine which
          # accounts for this.
          i.set(step_value: values.step)

      v = +values.user
      def = if (v? && !_.isNaN(v)) then v else values.default

      i.set({
        user_value: def
        # Disable if ET-Model *or* ET-Engine disable the input.
        disabled: i.get('disabled') || values.disabled
      }, { silent: true })

      @addInputElement(i)

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

  # Creates the slider view unless the item is already on screen
  #
  # inputElement - an input_element backbone object
  #
  addInputElement: (inputElement) =>
    return if inputElement.onscreen
    options = inputElement.ui_options
    @inputElements[inputElement.id] = inputElement

    if inputElement.get('unit') is 'boolean'
      view = new BooleanElementView({model : inputElement, el : options.element})
    else
      view = new InputElementView({model : inputElement, el : options.element})

    @inputElementViews[inputElement.id] = view
    view.bind "change", @handleUpdate
    inputElement.onscreen = true
    true

  # Triggers a new API request on AppView
  handleUpdate: => @trigger("change")

  close_all_info_boxes: =>
    v.closeInfoBox() for v in _.values(@inputElementViews)

  find_by_key: (k) =>
    @find (i) -> i.get('key') == k
