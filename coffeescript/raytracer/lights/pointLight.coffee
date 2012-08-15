class PointLight extends Light
  constructor: (lightToWorld, @intensity) ->
    super(lightToWorld)
    @lightPosition = Transform.TransformPoint lightToWorld, new Point()
    
  sampleRadiance: (p, pε, lightSample, time, visibility) ->
    wi = Vector.Normalise(Point.SubtractPointFromPoint @lightPosition, p)
    pdf = 1
    visibility.setSegment p, pε, @lightPosition, 0, time
    lpTop2 = Point.DistanceSquared @lightPosition, p
    radiantIntensity = Spectrum.Divide @intensity, lpTop2
    return [wi, pdf, visibility, radiantIntensity]
    
  power: ->
    Spectrum.Multiply @intensity, 4 * Math.PI
    
  isDeltaLight: ->
    yes
    
root = exports ? this
root.PointLight = PointLight