#
# @summary
#   Transform given Ferm::Port value(s) to String usable with ferm rules
#
# @example ferm::port_to_string(direction, port, negate)
#
#   ferm::port_to_string('destination', [22, '22:222'], true)
#   # => "mod multiport destination-ports !(22 '22:222')"
#
#   ferm::port_to_string('destination', '22:222', true)
#   # => "dport !22:222"
#
#   ferm::port_to_string('source', [22, 222], false)
#   # => "mod multiport source-ports (22 222)"
#
#   ferm::port_to_string('destination')
#   # => ""
#
#   ferm::port_to_string('source', 'foobar')
#   # => "invalid source-port: 'foobar'"
#
# @param direction
#   Either 'destination' or 'source'
#
# @param port
#   Ferm::Port (e.g. 22, '22:222', [ 22, 222 ], [ 22, '22:222' ])
#
# @param negate
#   Negate port/ports
#
# @return
#   String
#
function ferm::port_to_string (
  Enum['destination', 'source'] $direction,
  Optional[Ferm::Port]          $port   = undef,
  Boolean                       $negate = false,
) >> String {

  # return early
  #
  unless $port { return '' }

  $_negate = if $negate { '!' } else { '' }

  # ensure unique elements in flat Array
  #
  $ports = [ $port ].flatten.unique.map |Ferm::Port $element| {

    case $element {
      Pattern[/^\d*:\d+$/]: {
        $portrange = split($element, /:/)

        $lower = if $portrange[0].empty { 0 } else { Integer($portrange[0]) }
        $upper = Integer($portrange[1])

        assert_type(Tuple[Stdlib::Port, Stdlib::Port], [$lower, $upper]) |$expected, $actual| {
          fail("The data type should be \'${expected}\', not \'${actual}\'. The data is [${lower}, ${upper}])}.")
        }

        if $lower > $upper {
          fail("Lower port number of the port range is larger than upper. ${lower}:${upper}")
        }

        "${lower}:${upper}"
      }
      Integer: {
        $element
      }
      default: {
        fail("invalid ${direction}-port: ${_negate}${element}")
      }
    } # end case

  } # end map

  if $ports.length == 1 {

    "${direction[0]}port ${_negate}${ports[0]}"

  } else {

    "mod multiport ${direction}-ports ${_negate}(${ports.join(' ')})"

  } # end if
}
