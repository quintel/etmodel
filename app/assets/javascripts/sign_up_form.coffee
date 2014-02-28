class @SignUpForm extends Backbone.View
  events:
    'click .choice.individual': -> @setMode('individual')
    'click .choice.student':    -> @setMode('student')
    'click .choice.teacher':    -> @setMode('teacher')

  constructor:  ->
    super

    @optionEls =
      individual: @$('.selection.individual.choice')
      student:    @$('.selection.education.choice:first')
      teacher:    @$('.selection.education.choice:last')

    @render()

  # Once the user has selected a form mode, remove the opacity filter and enable
  # the fields.
  enableForm: ->
    @$('input').attr('disabled', false)
    @$('form').css('opacity', 1.0)

    unless (focusField = @$('input#user_name')).val()
      focusField.focus()

  # Used only when the page first loads. Reduces the opacity of the form and
  # disables all the fields, encouraging the user to select a form mode before
  # entering any details.
  disableForm: ->
    @$('input').attr('disabled', true)
    @$('form').css('opacity', 0.2)

  # Initial page and form setup.
  render: ->
    @$('.input.user_teacher_email').hide()

    if @$('input[name=mode]').val()
      @setMode(@$('input[name=mode]').val())
    else
      @disableForm()

  # Sets the "mode" of the form; showing fields relevant to the user depending
  # on whether they're an individual, teacher, or student.
  setMode: (mode) ->
    return if _.indexOf(['individual', 'teacher', 'student'], mode) is -1

    @enableForm()

    boxes  = [ @$('.selection.individual'), @$('.selection.education') ]

    onBox  = if mode == 'individual' then boxes[0] else boxes[1]
    offBox = if mode == 'individual' then boxes[1] else boxes[0]

    onBox.addClass('selected').removeClass('deselected')
    offBox.addClass('deselected').removeClass('selected')

    @$(".choice.#{ mode }").addClass('selected')
    @$(".choice:not(.#{ mode })").removeClass('selected')

    @$('input[name=mode]').val(mode)

    @setVisibleFields(mode)
    @setOrganisationTexts(mode)

  # When the user is student, we don't ask them for the company or school they
  # belong to (we can get that from the teacher), but instead ask for the e-mail
  # address of the teacher.
  setVisibleFields: (mode) ->
    if mode is 'student'
      @$('.input.user_company_school').hide()
      @$('.input.user_teacher_email').show()
    else
      @$('.input.user_company_school').show()
      @$('.input.user_teacher_email').hide()

  # Tweaks the form labels depending on the type of user being added.
  setOrganisationTexts: (mode) ->
    if mode is 'teacher'
      newLabel = I18n.t('simple_form.labels.user.school')
      newHint  = I18n.t('simple_form.hints.user.school')
    else
      newLabel = I18n.t('simple_form.labels.user.company_school')
      newHint  = I18n.t('simple_form.hints.user.company_school')

    labelEl = $(@$('.user_company_school label')[0])
    hintEl  = $(@$('.user_company_school .hint')[0])

    hintEl.text(newHint)

    labelEl.html("""
      #{ newLabel }
      <span class='optional'>#{ I18n.t('simple_form.optional') }</span>
    """)
