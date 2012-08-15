class MustBeOverriddenError extends Error

class Integrator
  
  preprocess: ->
    throw MustBeOverriddenError 'preprocess must be implemented by Integrator subclasses.'
    
  requestSamples: ->
    throw MustBeOverriddenError 'requestSamples must be implemented by Integrator subclasses.'
      
  @SpecularReflect: (r, bsdf, random, intersection, renderer, scene, sample) ->
    outgoingD = -ray.d
    p = bsdf.dgShading.point
    n = bsdf.dgShading.normalisedNormal
    f = bsdf.sampleF(outgoingD, BSDFSample(random), pdf, BSDFType)
    l = 0
    if pdf > 0 and not f.isBlack() and Vector.AbsDot(incident, n)
      #compute ray differential for specular reflection
      radiance = rendere.incidentRadiance(scene, rd, sample, random)
      l = f * radiance * Vector.AbsDot(incident, n) / pdf
    return l
    
  @SpecularTransmit: (r, bsdf, random, intersection, renderer, scene, sample) ->
    outgoingD = -ray.d
    p = bsdf.dgShading.point
    n = bsdf.dgShading.normalisedNormal
    f = bsdf.sampleF(outgoingD, BSDFSample(random), pdf, BSDFType)
    l = 0
    if pdf > 0 and not f.isBlack() and Vector.AbsDot(incident, n)
      #compute ray differential for specular reflection
      radiance = rendere.incidentRadiance(scene, rd, sample, random)
      l = f * radiance * Vector.AbsDot(incident, n) / pdf
    return l    
      
class SurfaceIntegrator extends Integrator
  
  radiance: ->
    throw MustBeOverriddenError 'radiance must be implemented by SurfaceIntegrator subclasses.'
      
root = exports ? this
root.Integrator = Integrator
root.SurfaceIntegrator = SurfaceIntegrator