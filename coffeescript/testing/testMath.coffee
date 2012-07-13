$(document).ready(->
  
  module("Math")
  
  test("MathFunctions.Clamp", ->
    low = 0
    middle = 5
    high = 10
    clampLow = MathFunctions.Clamp(-10, low, high)
    equal(clampLow, low, "clampLow is expected to be equal to low")
    clampHigh = MathFunctions.Clamp(20, low, high)
    equal(clampHigh, high, "clampHigh is expected to be equal to high")
    clampMiddle = MathFunctions.Clamp(middle, low, high)
    equal(clampMiddle, middle, "clampMiddle is expected to be equal to middle")
    return
  )
  
  test("MathFunctions.Degrees", ->
    equalWithin(MathFunctions.Degrees(Math.PI * 2), 360, 12, "2 * Pi Radians is expected to be equal to 360 Degrees")
    equalWithin(MathFunctions.Degrees(Math.PI), 180, 12, "Pi Radians is expected to be equal to 180 Degrees")
    equalWithin(MathFunctions.Degrees(Math.PI / 2), 90, 12, "Pi / 2 Radians is expected to be equal to 90 Degrees")
    equalWithin(MathFunctions.Degrees(Math.PI / 3), 60, 12, "Pi / 3 Radians is expected to be equal to 60 Degrees")
    equalWithin(MathFunctions.Degrees(Math.PI / 4), 45, 12, "Pi / 4 Radians is expected to be equal to 45 Degrees")
    equalWithin(MathFunctions.Degrees(Math.PI / 6), 30, 12, "Pi / 6 Radians is expected to be equal to 30 Degrees")
    return
  )
  
  test("MathFunctions.Radians", ->
    equal(MathFunctions.Radians(360), Math.PI * 2, "360 Degrees is expected to be equal to 2 * Pi Radians")  
    equal(MathFunctions.Radians(180), Math.PI, "180 Degrees is expected to be equal to Pi Radians")
    equal(MathFunctions.Radians(90), Math.PI / 2, "90 Degrees is expected to be equal to Pi / 2 Radians")
    equal(MathFunctions.Radians(60), Math.PI / 3, "60 Degrees is expected to be equal to Pi / 3 Radians")
    equal(MathFunctions.Radians(45), Math.PI / 4, "45 Degrees is expected to be equal to Pi / 4 Radians")
    equal(MathFunctions.Radians(30), Math.PI / 6, "30 Degrees is expected to be equal to Pi / 6 Radians")
    return
  )
  
  test("MathFunction.LinearInterpolation", ->
    equal(MathFunctions.LinearInterpolation(0.666, 0, 10), 6.66, "LinearInterpolation of 0.666 from 0 to 10 is expected to be 6.66")
    equal(MathFunctions.LinearInterpolation(-0.5, 0, 10), -5, "LinearInterpolation of -0.5 from 0 to 10 is expected to be -5")
  )
  
  test("MathFunctions.Mod", ->
    equal(MathFunctions.Mod(27, 16), 11, "27 % 16 is expected to equal 11")
    equal(MathFunctions.Mod(4, 4), 0, "4 % 4 is expected to equal 0")
    equal(MathFunctions.Mod(-3, 4), 1, "-3 % 4 is expected to equal 1")
    return
  )
  
  test("MathFunctions.SolveLinearSystem2x2", ->
    a = [[2,3],[4,9]]
    b = [6,15]
    [consistent, x1, x2] = MathFunctions.SolveLinearSystem2x2(a, b)
    equal(consistent, true, "consistent is expected to be equal to true")
    equal(x1, 1.5, "x1 is expected to be equal to 1.5")
    equal(x2, 1, "x2 is expected to be equal to 1")
    a = [[3,2],[3,2]]
    b = [6,12]
    [consistent, x1, x2] = MathFunctions.SolveLinearSystem2x2(a, b)
    equal(consistent, false, "consistent is expected to be equal to false")
    equal(x1, null, "x1 is expected to be equal to null")
    equal(x2, null, "x2 is expected to be equal to null")
  )
)