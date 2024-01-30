# @summary ferm port-spec
#
# allowed variants:
# -----------------
# + single Integer port
# + ferm range port-spec (pair of colon-separated integer, assumes 0 if first is omitted)
# + array of interger port(s) and/or ferm range port-spec(s)
type Ferm::Port = Variant[
  Array[Ferm::Port],
  Stdlib::Port,
  Pattern['^\d*:\d+$'],
]
