class Light
  constructor: (@lightToWorld, @numberSamples = 1) ->
    @worldToLight = Transform.InverseTransform @lightToWorld
    if @lightToWorld.hasScale()
      throw Error
      
  sampleRadiance: ->
    
  power: ->
    
  isDeltaLight: ->
    
class VisibilityTester
  constructor: ->
    
  setSegment: (p1, ε1, p2, ε2, t) ->
    distance = Point.Distance p1, p2
    p2p1distance = Point.SubtractPointFromPoint(p1, p2).divide distance
    distance1ε2 = distance * (1 - ε2)
    @r = new Ray(p1, p2p1distance, ε1, null, distance1ε2, t)
    
  setRay: (p, ε, dir, t) ->
    @r = new Ray(p, dir, ε, null, Infinity, t)
    
  unoccluded: (scene) ->
    return not scene.intersectP @r
    
  transmittance: (scene, renderer, sample, random) ->
    rayDiff = RayDifferential.FromRay @r
    renderer.transmittance scene, rayDiff, sample, random