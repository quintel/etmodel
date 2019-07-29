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

    @bind('change:user_value', (input) =>
      App.analytics.inputChanged(input.get('key'))
    )

  conversions: ->
    conversions = @get('conversions') or []

    if App.settings.get_scaling() and Quantity.isSupported(@get('unit'))
      base = new Quantity(
        # If start value is zero, we can't scale down to a different unit, as it
        # will always default to the smallest possible. In these cases, try the
        # maximum.
        @get('start_value') || @get('max_value'),
        @get('unit')
      )

      scaled = base.smartScale()

      if scaled.unit.power.multiple < base.unit.power.multiple
        conversions = conversions.slice()

        conversions.push({
          default:    true
          unit:       scaled.localizedUnit()
          multiplier: base.unit.power.multiple / scaled.unit.power.multiple
        })

    conversions

  logUpdate: =>
    App.debug "Slider #{@get 'key'}: #{@get('user_value')}"

  # The lowest value which should be shown on the input element.
  #
  # If this is not set, or the value is higher than the input mininum value, the
  # input minimum is returned instead.
  #
  # Returns a number.
  drawToMin: ->
    unless this.get('draw_to_min')?
      return this.get('min_value')

    Math.min(this.get('draw_to_min'), this.get('min_value'))

  # The highest value which should be shown on the input element.
  #
  # If this is not set, or the value is lower than the input maxinum value, the
  # input maximum is returned instead.
  #
  # Returns a number.
  drawToMax: ->
    unless this.get('draw_to_max')?
      return this.get('max_value')

    Math.max(this.get('draw_to_max'), this.get('max_value'))

  # if we're caching the user_values hash then we have to store locally the
  # user_values, without querying the engine
  update_collection: =>
    App.input_elements.user_values[@get('key')]['user'] = @get('user_value')

  # Returns if this is dirty, meaning a attribute has changed.
  isDirty: => if @get('fixed') == true then false else @dirty

  markDirty: => @dirty = true

  setDirty: (dirty) => @dirty = dirty

  does_want_reset: =>
    @get('wants_reset') && @get('user_value') == @get('start_value')

  reset: (opts) =>
    @set({ wants_reset: true, user_value: @get('start_value') }, opts)

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

    for input in @dirty()
      out[input.get('key')] =
        if input.does_want_reset()
          'reset'
        else
          input.get('user_value')

    out

  dirty: =>
    @select (el) -> el.isDirty()

  reset_dirty: =>
    _.each @dirty(), (el) ->
      el.set({ wants_reset: false }, { silent: true })
      el.setDirty(false)

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
