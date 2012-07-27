$(document).ready ->
  
  module 'MathFunctions - functions'
  
  test 'Test that all functions exist on the MathFunctions object:', ->
    expect 7
    ok MathFunctions?, 'If we look at the MathFunctions object'
    ok MathFunctions.Clamp?, 'it should have the "Clamp" function'
    ok MathFunctions.Degrees?, 'and the "Degrees" function'
    ok MathFunctions.Radians?, 'and the "Radians" function'
    ok MathFunctions.LinearInterpolation?, 'and the "LinearInterpolation" function'
    ok MathFunctions.Mod?, 'and the "Mod" function'
    ok MathFunctions.SolveLinearSystem2x2?, 'and the "SolveLinearSystem2x2" function'
  
  test 'Test that "MathFunctions.Clamp" works correctly for various inputs:', ->
    expect 3
    testClamp = (val, low, high, expected) ->
      result = MathFunctions.Clamp val, low, high
      equal result, expected, "The result of 'Clamp #{val}, #{low}, #{high}' is expected to be #{expected}."
    testClamp -5, 0, 10, 0
    testClamp 15, 0, 10, 10
    testClamp 5, 0, 10, 5
  
  test 'Test that "MathFunctions.Degrees" works correctly for various inputs:', ->
    expect 9
    π = Math.PI
    testDegrees = (radians, expected) ->
      result = MathFunctions.Degrees radians
      equalWithin result, expected, 12, "The result of 'Degrees #{radians}' is expected to be #{expected}"
    testDegrees 2 * π, 360
    testDegrees π, 180
    testDegrees π / 2, 90
    testDegrees π / 3, 60
    testDegrees π / 4, 45
    testDegrees π / 6, 30
    testDegrees π / 9, 20
    testDegrees π / 12, 15
    testDegrees π / 18, 10
  
  test 'Test that "MathFunctions.Radians" works correctly for various inputs:', ->
    expect 9
    π = Math.PI
    testDegrees = (degrees, expected) ->
      result = MathFunctions.Radians degrees
      equal result, expected, "The result of 'Radians #{degrees}' is expected to be #{expected}"
    testDegrees 360,  2 * π
    testDegrees 180, π
    testDegrees 90, π / 2
    testDegrees 60, π / 3
    testDegrees 45, π / 4
    testDegrees 30, π / 6
    testDegrees 20, π / 9
    testDegrees 15, π / 12
    testDegrees 10, π / 18
  
  test 'Test that "MathFunction.LinearInterpolation" works correctly for various inputs:', ->
    expect 4
    testLerp = (t, v1, v2, expected) ->
      result = MathFunctions.LinearInterpolation t, v1, v2
      equal result, expected, "The result of 'LinearInterpolation #{t}, #{v1}, #{v2}' is expected to be #{expected}"
    testLerp 2, 0, 5, 10
    testLerp 0.666, 0, 10, 6.66
    testLerp -0.5, 0, 10, -5
    testLerp -4, 0, 4, -16
  
  test 'Test that "MathFunctions.Mod" works correctly for various inputs:', ->
    expect 3
    testMod = (a, b, expected) ->
      result = MathFunctions.Mod(a, b)
      equal result, expected, "The result of 'Mod(#{a}, #{b})' is expected to be #{expected}"
    testMod 27, 16, 11
    testMod 4, 4, 0
    testMod -3, 4, 1
  
  test 'Test that "MathFunctions.SolveLinearSystem2x2" works correctly for various inputs:', ->
    expect 6
    testSolveLinear = (a, b, expected) ->
      [consistent, x0, x1] = MathFunctions.SolveLinearSystem2x2 a, b
      [resultC, resultX0, resultX1] = expected
      isConsistent = if resultC then 'consistent.' else 'inconsistent.'
      equal consistent, resultC, "The result of 'SolveLinearSystem2x2 #{a}, #{b}' is expected to be #{isConsistent}"
      equal x0, resultX0, "For 'SolveLinearSystem2x2 #{a}, #{b}', X0 is expected to be #{resultX0}"
      equal x1, resultX1, "For 'SolveLinearSystem2x2 #{a}, #{b}', X1 is expected to be #{resultX1}"
    testSolveLinear [[2,3],[4,9]], [6,15], [true, 1.5, 1]
    testSolveLinear [[3,2],[3,2]], [6,12], [false, null, null]