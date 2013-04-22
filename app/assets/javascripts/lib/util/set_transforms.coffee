ROUND = (value) ->
  Math.round(value)

NEAREST_FIFTY = (value) ->
  modulus = value % 50
  if modulus >= 25
    value + (50 - modulus)
  else
    value - modulus

window.forSet = (set) ->
  newSet = {}

  for key of set
    if found = TRANSFORMS[ key ]
      newSet[key] = found(set[key])
    else
      newSet[key] = set[key]

  newSet

TRANSFORMS =
  full_load_hours: NEAREST_FIFTY
  profit_per_mwh_electricity: ROUND
