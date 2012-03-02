class @MekkoChartView extends BaseChartView
  initialize: ->
    @initialize_defaults()

  render: =>
    @clear_container()

    InitializeMekko(@model.get("container"), 
      @results(),
      @parsed_unit(),
      @colors(),
      @labels(),
      @group_labels())

  results: ->
    scale = @data_scale()
    series = {}
    values = []
    # RD: push the serie results in the defined groups
    @model.series.each (serie) ->
      group = serie.get('group')
      if group
        if (!series[group]) then series[group] = []
        series[group].push(serie.result_pairs()[0])
        values.push(serie.result_pairs()[0])
    results = _.map series, (sector_values, sector) ->
      return _.map sector_values, (value) ->
        return Metric.scale_value(value, scale)
    results

  colors: ->
    _.uniq(this.model.colors())

  labels: ->
    labels = this.model.labels()
    # TODO: the old model also has percentage per group. was ommited to simplify things.
    return _.uniq(labels)

  group_labels:->
    group_labels = this.model.series.map (serie) -> serie.get('group_translated')
    return _.uniq(group_labels)
