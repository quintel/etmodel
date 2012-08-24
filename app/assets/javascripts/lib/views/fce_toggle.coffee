# Creates the FCE toggle switch and labels.
#
# Usage:
#
#   new FCEToggle(el: $('.fce-toggle'), model: App.settings).render()
#
class @FCEToggle extends Backbone.View
  className: 'fce-toggle'

  # Creates the toggle switch, sets up Quinn, and makes the labels.
  render: ->
    super

    @$el.empty()

    @offEl    = $("<div class='off'>#{ I18n.t('fce_toggle.off') }</div>")
    @onEl     = $("<div class='on'>#{ I18n.t('fce_toggle.on') }</div>")
    @widgetEl = $("<div class='widget'></div>")

    @$el.append(@offEl).append(@widgetEl).append(@onEl)

    @quinn = new jQuery.Quinn @widgetEl,
      min:         0
      max:         95 # One pixel per "step".
      value:       if @model.get('use_fce') then 95 else 0
      effectSpeed: 150
      renderer:    Renderer
      change:      @onQuinnChange

    @setLabelActiveStates(@model.get('use_fce'))

    @onEl.on  'click', => @model.set(use_fce: true)
    @offEl.on 'click', => @model.set(use_fce: false)

    # Changes elsewhere should update the toggle switch.
    @model.on 'change:use_fce', (model, fceEnabled) =>
      @quinn.setValue(
        @quinn.model[ if fceEnabled then 'maximum' else 'minimum' ])

    this

  # Callback for when the user changes the toggle switch.
  onQuinnChange: (value, quinn) =>
    if value < quinn.model.maximum / 2
      correctedValue = quinn.model.minimum
      fceStatus      = off
    else
      correctedValue = quinn.model.maximum
      fceStatus      = on

    if value isnt correctedValue
      # User didn't move the handle all the way.
      quinn.setTentativeValue(correctedValue)

    @setLabelActiveStates(fceStatus)
    @model.set(use_fce: fceStatus)

    true

  # Sets the on/off label to be marked as active/inactive depending on the FCE
  # status.
  setLabelActiveStates: (isEnabled) ->
    if isEnabled
      @offEl.removeClass('active')
      @onEl.addClass('active')
    else
      @offEl.addClass('active')
      @onEl.removeClass('active')

# Cutomises the Quinn renderer so that the handle appears entirely within the
# bar, instead of overhanging the edges.
class Renderer extends jQuery.Quinn.Renderer
  render: ->
    super

    @bar.css('marginLeft',  '-20px')
    @bar.css('paddingRight', '31px')

    @handles[0].
      css('marginLeft', '-4px').
      on('mousedown',  @handleDown).
      on('touchstart', @handleDown).
      on('mouseup',    @handleUp).
      on('touchend',   @handleUp).
      on('click', -> console.log('click'))

  handleDown: =>
    @timeOfClick = new Date

  # A fast click toggles the value.
  handleUp: =>
    if @timeOfClick? and new Date() - @timeOfClick < 250
      @quinn.setValue(@model.maximum - @model.value)

  redrawDeltaBar: (value, handle) ->
    super
    @deltaBar.css('right', '+=6')
