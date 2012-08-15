class DistantLight extends Light
  constructor: (lightToWorld, @radiance, direction) ->
    super(lightToWorld)
    lightDir = Transform.TransformVector lightToWorld, direction
    @lightDirection = Vector.Normalise lightDir
    
  sampleRadiance: (p, pε, lightSample, time, visibility) ->
    visibility.setRay p, pε, @lightDirection, time
    return [@lightDirection, 1, visibility, @radiance]
    
  power: (scene) ->
    [center, radius] = scene.WorldBound().BoundingSphere()
    πr2 = Math.PI * radius * radius
    Spectrum.Multiply @radiance, πr2

root = exports ? this
root.DistantLight = DistantLight