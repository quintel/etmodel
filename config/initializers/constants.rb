MWH_TO_GJ = 3.6
HOURS_PER_YEAR = 8760.0
SECS_PER_HOUR = 3600.0
SECS_PER_YEAR = SECS_PER_HOUR * HOURS_PER_YEAR
MJ_TO_MHW = 3600
BILLIONS = 10.0**9
MJ_TO_PJ = BILLIONS
MILLIONS = 10.0**6
# QUESTION: Why do we define here a 'shortcut' for nil?, DS
# ANSWER: For the GQL. so we could write EQUALS(V(..); NIL)
#         Will remove it, cause already defined by ruby... But want to test properly
NIL = nil if !defined?(NIL)
EURO_SIGN = '&euro;'