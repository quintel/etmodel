$ ->
  # Select2 template for region select options.
  areaTemplate = (state) ->
    if !state.id
      return state.text

    root  = $("<span/>")
    flag  = $(".flags .#{state.id.toLowerCase()}").clone()
    inner = $("<span/>").text(state.text)

    if flag.length > 0
      root.append(flag)

    root.append(inner) # .attr('id', state.id)

  # Select2 template for area select options.
  yearTemplate = (state) ->
    if !state.id
      return state.text

    $('<span/>').append(
      $('<span class="present">' + I18n.t('period.present') + ' &ndash;</span>'),
      ' ',
      state.text
    )

  areaSelect = $("#new-scenario select[name=area_code]")
  sYearSelect = $("#new-scenario select[name=end_year]")

  selectedYear = sYearSelect.val()

  areaSelect.select2(
    templateResult: areaTemplate,
    templateSelection: areaTemplate,
    dropdownParent: $('#area-select-options'),
    width: '348px'
  )

  sYearSelect.select2(
    templateResult: yearTemplate,
    templateSelection: yearTemplate
    minimumResultsForSearch: -1,
    dropdownAutoWidth: true,
    width: '150px'
  )

  # Set the area and end year for the CO2 factsheet link.
  setParamForEstablishmentShot = ->
    $('.co2-factsheet a').attr(
      'href',
      '/regions/' + areaSelect.val()
    )

  # Adds options for individual years in the year select.
  populateIndividualYears = (reopenDropdown = true) ->
    earliest = areaSelect.find(':selected').data('earliest')
    standard = sYearSelect.find('option').map (i, o) -> parseInt(o.value, 10)
    latest   = _.max(standard)

    sYearSelect.empty()

    for year in [earliest..latest]
      sYearSelect.append($("<option value='#{ year }'>#{year}</option>"))

    sYearSelect.val(Math.max(selectedYear, earliest))
    sYearSelect.trigger('change')

    # Re-open the select after the event has finished.
    if reopenDropdown
      window.setTimeout((-> sYearSelect.select2('open')), 1)

  updateYearSelect = ->
    if sYearSelect.val() == 'other'
      populateIndividualYears()

  applyEarliestYearFilter = ->
    unless sYearSelect.find('option[value=other]').length
      populateIndividualYears(false)

  areaSelect.change(setParamForEstablishmentShot)
  areaSelect.change(applyEarliestYearFilter)

  sYearSelect.change(setParamForEstablishmentShot)
  sYearSelect.change(updateYearSelect)

  sYearSelect.change ->
    selectedYear = sYearSelect.val()

  setParamForEstablishmentShot()
  applyEarliestYearFilter()
