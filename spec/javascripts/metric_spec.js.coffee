#= require 'lib/models/metric'
#= require 'i18n'
#= require 'i18n/translations'

describe "Metric", ->
  it "should scale values and units", ->
    expect(Metric.autoscale_value(100, 'PJ')).toEqual('100 PJ')
    expect(Metric.autoscale_value(1000, 'PJ')).toEqual('1 EJ')

  it "should be able to scale the unit", ->
    expect(Metric.scale_unit(100, 'PJ')).toEqual('PJ')
    expect(Metric.scale_unit(1000, 'PJ')).toEqual('EJ')