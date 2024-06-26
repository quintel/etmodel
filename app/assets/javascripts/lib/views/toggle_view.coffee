# A Base class for toggle elements such as the merit order toggle.
#
# Subclasses need to implement:
#
#   attr   - The name of the attribute on the model whose value is set by the
#            toggle widget.
#   render - Your `render` method should call `renderWidget` which sets up the
#            "on" / "off" labels and the Quinn widget.
#
class ToggleView extends Backbone.View
  onValue:  on
  offValue: off

  # Renders the toggle element itself into the given element. This includes
  # the "on" / "off" labels, and the Quinn widget.
  renderWidget: (into) ->
    @offEl    = $("<div class='off'>#{ I18n.t('toggle.off') }</div>")
    @onEl     = $("<div class='on'>#{ I18n.t('toggle.on') }</div>")
    @widgetEl = $("<div class='widget'></div>")

    $(into).append(@offEl).append(@widgetEl).append(@onEl)

    @quinn = new jQuery.Quinn @widgetEl,
      min:         0
      max:         1 # One pixel per "step".
      value:       if @model.get(@attr) then 1 else 0
      effectSpeed: 150
      renderer:    Renderer
      change:      @onQuinnChange

    @setLabelActiveStates(@model.get(@attr))

    @onEl.on  'click', => @quinn.setValue(@quinn.model.maximum)
    @offEl.on 'click', => @quinn.setValue(@quinn.model.minimum)

    # Changes elsewhere should update the toggle switch.
    @model.on "change:#{ @attr }", (model, status) =>
      @quinn.setValue(@quinn.model[ if status then 'maximum' else 'minimum' ])

  # Callback for when the user changes the toggle switch.
  onQuinnChange: (value, quinn) =>
    if value < quinn.model.maximum / 2
      correctedValue = quinn.model.minimum
      boolValue      = @offValue
    else
      correctedValue = quinn.model.maximum
      boolValue      = @onValue

    if value isnt correctedValue
      # User didn't move the handle all the way.
      quinn.setTentativeValue(correctedValue)

    @setLabelActiveStates(boolValue)
    @model.set(@attr, boolValue)
    @trigger('change')

    true

  # Sets the on/off label to be marked as active/inactive depending on the
  # model's value.
  setLabelActiveStates: (isEnabled) ->
    if isEnabled
      @offEl.removeClass('active')
      @onEl.addClass('active')
    else
      @offEl.addClass('active')
      @onEl.removeClass('active')

# BooleanElementView ---------------------------------------------------------

# This is an alternative to InputElementView, and is used whenever an input
# has the unit "boolean". A large toggle switch is rendered instead of the
# ordinary slider, with a true / false value sent back to ETengine.
class @BooleanElementView extends ToggleView
  attr: 'user_value'

  offValue: 0
  onValue:  1

  # For compatibility with InputElementView, the boolean element is
  # immediately rendered when initialized.
  constructor: ->
    super
    @render()

  render: ->
    super

    @$el.empty()
    @renderWidget($('<div class="toggle-view"></div>').appendTo(@$el))

    if @model.get('sanitized_description').length
      @$el.prepend($('<p class="toggle-description"></p>')
        .html(@model.get('sanitized_description')))

    if @model.get('translated_name').length
      @$el.prepend($('<p class="toggle-title"></p>')
        .html(@model.get('translated_name')))

    this

  # Stubs to be API-compatiable with InputElementView
  closeInfoBox: ->

# Renderer -------------------------------------------------------------------

# Cutomises the Quinn renderer so that the handle appears entirely within the
# bar, instead of overhanging the edges.
class Renderer extends jQuery.Quinn.Renderer
  render: ->
    super

    [ onEvent, offEvent ] =
      if 'ontouchstart' of document.documentElement
        [ 'touchstart', 'touchend' ]
      else
        [ 'mousedown', 'mouseup' ]

    # Style adjustments.
    @bar.css('marginLeft', '-20px')

    # "Fast" click events.
    @handles[0].on(onEvent, @handleDown)
    @bar.on(onEvent, @handleDown).on(offEvent, @handleUp)

    # Remove the default Quinn events.
    @wrapper.off('mousedown',  @quinn.clickBar)
    @wrapper.off('touchstart', @quinn.clickBar)

  handleDown: =>
    @timeOfClick = new Date

  # A fast click toggles the value.
  handleUp: =>
    if @timeOfClick? and new Date() - @timeOfClick < 250
      @quinn.setValue(@model.maximum - @model.value)

  redrawDeltaBar: (value, handle) ->
    super
    @deltaBar.css('right', '+=6')

  position: (value, ignoreOverhang) ->
    super - 1
