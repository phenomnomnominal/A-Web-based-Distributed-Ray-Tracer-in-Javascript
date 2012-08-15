class AreaLight extends Light
  radiance: ->
    
  emitted: (w) ->
    area = primitive.getAreaLight()
    if area? then area.radiance(dg.p, dg.nn, w) else new Spectrum(0)