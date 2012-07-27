# *math.coffee* contains the [**`MathFunctions`**](#math) object.
# ___

# ## <section id='math'>MathFunctions:</section>
# ___
# The **`MathFunction`** object contains additional mathematical methods that are used throughout this project.
MathFunctions = {}

# `Math.PI` is reassigned to `π` for readability:
π = Math.PI

#___
# ### Functions:

# ### *Clamp:*
# > **`MathFunctions.Clamp`** clamps a given value between a high and a low value.
MathFunctions.Clamp = (val, low, high) ->
  if val < low 
    return low
  else if val > high
   return high
  return val

# ### *Degrees:*
# > **`MathFunctions.Degrees`** converts an angle expressed as radians into degrees.
MathFunctions.Degrees = (rad) ->
  return (180 / π) * rad

# ### *Radians:*
# > **`MathFunctions.Radians`** converts an angle expressed as degrees into radians.
MathFunctions.Radians = (deg) ->
  return (π / 180) * deg

# ### <section id='lerp'>*LinearInterpolation:*</section>
# > **`MathFunctions.LinearInterpolation`** performs a Linear Interpolation between two values, with the interpolation value given by the parameter `t`.
MathFunctions.LinearInterpolation = (t, v1, v2) ->
  return (1 - t) * v1 + t * v2

# ### *Mod:*
# > **`MathFunctions.Mod`** computes the remainder of `a / b`. Better than the native JavaScript `%` operator, as it behaves predictably and correctly for negative values.
MathFunctions.Mod = (a, b) ->
  return ((a % b) + b) % b

# ### *SolveLinearSystem2x2:*
# > **`MathFunctions.SolveLinearSystem2x2`** solves a linear system of the form:
# >> *( a<sub>00</sub> a<sub>01</sub> )* *(x<sub>0</sub>)* = *(b<sub>0</sub>)*  
# >> *( a<sub>10</sub> a<sub>11</sub> )* *(x<sub>1</sub>)* = *(b<sub>1</sub>)*  
#
# If the system can be solved, `consistency` is set to `true`, and `x0` and `x1` set to the results, otherwise, `consistency` is set to `false`, and `x0` and `x1` are `null`.
MathFunctions.SolveLinearSystem2x2 = (a, b) ->
  determinant = a[0][0]*a[1][1] - a[0][1]*a[1][0]
  if Math.abs(determinant) < 0.0000000001 
    return [false, null, null]
  x0 = (a[1][1]*b[0] - a[0][1]*b[1]) / determinant
  x1 = (a[0][0]*b[1] - a[1][0]*b[0]) / determinant
  if isNaN(x0) or isNaN(x1)
    return [false, null, null]
  return [true, x0, x1]
    
# ___
# ## Exports:

# The [**`MathFunctions`**](#math) object is added to the global `root` object.
root = exports ? this
root.MathFunctions = MathFunctions