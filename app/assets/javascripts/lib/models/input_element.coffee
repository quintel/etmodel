# disabledInputs is a map of input keys to Sets, where the set contains keys describing a feture
# which requires that the input be disabled. Only if the set is empty is the input enabled.
disabledInputs = {}

class @InputElement extends Backbone.Model
  initialize: ->
    @dirty = false
    @on_screen = false
    @ui_options = element: $("#input_element_#{@get('key')}")
    @bind('change:user_value', @markDirty)
    @bind('change:user_value', @logUpdate)
    @bind('change:user_value', @update_collection)
    @bind('change:user_value', @additional_callbacks)

    @bind('change:user_value', (input) =>
      App.analytics.inputChanged(input.get('key'))
    )

    if @get('unit') == 'boolean'
      @bind('change:user_value', @handle_boolean_callbacks)
      @bind('initial-set:user_value', @handle_boolean_callbacks)
      @handle_boolean_callbacks()

  isDisabled: ->
    @get('disabled') || App.scenario.isReadOnly()

  isCoupled: ->
    this.isDisabled() && @get('coupling_disabled')

  conversions: ->
    conversions = @get('conversions') or []

    if Quantity.isSupported(@get('unit'))
      base = new Quantity(
        # Use the value of the slider when it is exactly half way between the
        # min and max to determine how to scale the unit. Using the start
        # value is no good, as a slider whose start value is zero would always
        # scale to the smallest SI unit.
        (@get('start_value') + @get('max_value')) / 2,
        @get('unit')
      )

      scaled = base.smartScale()

      if scaled.unit.power.multiple < base.unit.power.multiple &&
          scaled.unit != base.unit
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
    if @get('unit') == 'radio'
      this.handle_radio_callbacks()

  handle_radio_callbacks: ->
    enabled = @get('user_value') != "default"

    # Handle when_true, when_false config
    { when_not_default } = (@get('config') || {})

    if when_not_default && when_not_default.disables
      for key in when_not_default.disables
        @collection.markInputDisabled(key, @get('key'), enabled)

  handle_boolean_callbacks: ->
    enabled = @get('user_value') || false

    # Handle when_true, when_false config
    { when_true, when_false } = (@get('config') || {})

    if when_true && when_true.disables
      for key in when_true.disables
        @collection.markInputDisabled(key, @get('key'), enabled)

    if when_false && when_false.disables
      for key in when_false.disables
        @collection.markInputDisabled(key, @get('key'), !enabled)

  # Returns the step value of the input, except in cases where the step would
  # be too small to be meaningful (e.g. in small datasets), in which case the
  # step will be scaled down to ensure roughly 100 steps between the min and
  # max values.
  smartStep: ->
    if @smartStepValue
      return @smartStepValue

    step = @get('step_value')
    delta = @get('max_value') - @get('min_value')

    if delta > 0
      while (step * 20) > delta
        step /= 10

    @smartStepValue = step

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
        permitted_values: values.permitted_values
        start_value: values.default
        label: if _.isObject(values.label) then values.label else null

      if App.settings.get_scaling()
        if ! i.get('step_value') || i.get('step_value') > values.step
          # When region scaling, the pre-defined input step is too large for
          # some inputs. We therefore use the values from ETEngine which
          # accounts for this.
          i.set(step_value: values.step)

      v = if values.unit == "enum" then values.user else +values.user
      def = if (v? && !_.isNaN(v)) then v else values.default
      # Disable if ET-Model *or* ET-Engine disable the input.
      dis = this.isDisabled(i.get('key')) || i.get('disabled') || values.disabled

      i.set({
        user_value: def
        disabled: dis
        coupled: dis && values.coupling_disabled
        coupling_groups: values.coupling_groups
      }, { silent: true })

      i.trigger('initial-set:user_value')
      i.trigger('initial-set:disabled')
      i.trigger('initial-set:coupled')

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
    @inputElements[inputElement.get('key')] = inputElement

    switch inputElement.get('unit')
      when 'boolean'
        view = new BooleanElementView({model : inputElement, el : options.element})
      when 'radio'
        view = new RadioCollectionView(model: inputElement, el: options.element)
      when 'weather-curves'
        view = new WeatherCurveView(model: inputElement, el: options.element)
      else
        view = new InputElementView({model : inputElement, el : options.element})

    @inputElementViews[inputElement.get('key')] = view
    view.bind "change", @handleUpdate
    inputElement.onscreen = true
    true

  # Triggers a new API request on AppView
  handleUpdate: => @trigger("change")

  close_all_info_boxes: =>
    v.closeInfoBox() for v in _.values(@inputElementViews)

  find_by_key: (k) =>
    @find (i) -> i.get('key') == k

  # Flags an input as disabled (or not disabled) by a front-end feature. A feature key is required
  # as more than one front-end feature may require that an input be disabled. For example, removing
  # a custom curve should not cause an input to become disabled when a custom weather year also
  # requires that the input be disabled.
  #
  # key      - The input key.
  # feature  - A key identifying the feature disabling or un-disabling the input.
  # disabled - Boolean indicating if the input is disabled (true) or enabled (false).
  markInputDisabled: (key, feature, disabled = true) ->
    inputStatus = (disabledInputs[key] ||= new Set())

    if disabled
      inputStatus.add(feature)
    else
      inputStatus.delete(feature)

    if @find_by_key(key)
      isDisabled = this.isDisabled(key)

      @find_by_key(key).set({
        disabled: isDisabled
        disabledByFeature: isDisabled
      })

  # Returns if one or more features require the input to be disabled.
  isDisabled: (key) ->
    disabledInputs[key] && disabledInputs[key].size > 0
