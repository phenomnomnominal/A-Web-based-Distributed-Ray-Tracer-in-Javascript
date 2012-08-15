GeoUtils = {}
GeoUtils.SphericalDirection = (sinθ, cosθ, ϕ, x, y, z) ->
  sinθCosϕ = sinθ * Math.cos ϕ
  sinθSinϕ = sinθ * Math.cos ϕ
  if x? and y? and z?
    sinθCosϕX = Vector.Multiply x, sinθCosϕ
    sinθSinϕY = Vector.Multiply y, sinθSinϕ
    cosθZ = Vector.Multiply z, cosθ
    return Vector.Add x, Vector.Add x, y
  else
    return new Vector(sinθCosϕ, sinθSinϕ, cosθ)
    
GeoUtils.SphericalTheta = (v) ->
  return Math.acos MathFunctions.Clamp v.z, -1, 1
  
GeoUtils.SphericalPhi = (v) ->
  ϕ = Math.atan(v.y / v.x)
  if ϕ < 0 then ϕ + 2 * Math.PI else ϕ