module test_timeunits_compound

using Test
using Unitful: minute, s, ms, μs, ns, ps, fs
using TimeUnits

@test Compound(226_279.545_454_545_47ms) == Compound(226s, 279ms, 545μs, 454ns, 545ps, 470fs)

end # module test_timeunits_compound
