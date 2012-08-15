class DiffuseAreaLight extends AreaLight
  constructor: (lightToWorld, @emitted, ns, shape) ->
    super(lightToWorld, ns)
    @shapeSet = new ShapeSet(shape)
    @area = @shapeSet.area()
    
  radiance: (p, n, w) ->
    if Vector.Dot(n, w) > 0 then @emitted else new Spectrum(0)
    
  power: ->
    Spectrum.Multiply @emitted, @area * Math.PI
    
  isDeltaLight: ->
    false
    
root = exports ? this
root.DiffuseAreaLight = DiffuseAreaLight