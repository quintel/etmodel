#= require 'lib/models/metric'
#= require 'i18n'
#= require 'i18n/translations'

describe "Metric", ->
  it "should scale values and units", ->
    expect(Metric.autoscale_value(0.1, 'PJ')).toEqual('0.1 PJ')
    expect(Metric.autoscale_value(1, 'PJ')).toEqual('1 PJ')
    expect(Metric.autoscale_value(10, 'PJ')).toEqual('10 PJ')
    expect(Metric.autoscale_value(100, 'PJ')).toEqual('100 PJ')
    expect(Metric.autoscale_value(1000, 'PJ')).toEqual('1 EJ')

  it "should be able to scale the unit", ->
    expect(Metric.scale_unit(100, 'PJ')).toEqual('PJ')
    expect(Metric.scale_unit(1000, 'PJ')).toEqual('EJ')

  it "should show the right number of decimal digits", ->
    expect(Metric.format_number(2000)).toEqual('2000')
    expect(Metric.format_number(100)).toEqual('100.00')
    expect(Metric.format_number(10)).toEqual('10.00')
    expect(Metric.format_number(1)).toEqual('1.00')
    expect(Metric.format_number(0.012)).toEqual('0.012')