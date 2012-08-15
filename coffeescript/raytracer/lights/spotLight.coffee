class SpotLight extends Light
  constructor: (lightToWorld, @intensity, width, fall) ->
    super(lightToWorld)
    @lightPosition = Transform.TransformPoint lightToWorld, new Point()
    @cosTotalWidth = Math.cos MathFunctions.Radians width
    @cosFalloffStart = Math.cos MathFunctions.Radians fall
    
  sampleRadiance: (p, pε, lightSample, time, visibility) ->
    wi = Vector.Normalise(Point.SubtractPointFromPoint @lightPosition, p)
    pdf = 1
    visibility.setSegment p, pε, @lightPosition, 0, time
    falloffIntensity = Spectrum.Multiply @intensity, falloff(wi)
    lpTop2 = Point.DistanceSquared @lightPosition, p
    radiantIntensity = Spectrum.Divide falloffIntensity, lpTop2
    return [wi, pdf, visibility, radiantIntensity]
    
  falloff: (w) ->
    wLight = Vector.Normalise Transform.TransformVector w
    cosθ = wLight.z
    if cosθ < @cosTotalWidth
      return 0
    if cosθ > @cosFalloffStart
      return 1
    δ = (cosθ - @cosTotalWidth) / (@cosFalloffStart - @cosTotalWidth)
    δ * δ * δ * δ
    
  power: ->
    multiplier = 2 * Math.PI * ( 1 - 0.5 * (@cosFalloffStart + @cosTotalWidth))
    Spectrum.Multiply @intensity, mutliplier
    
root = exports ? this
root.SpotLight = SpotLight