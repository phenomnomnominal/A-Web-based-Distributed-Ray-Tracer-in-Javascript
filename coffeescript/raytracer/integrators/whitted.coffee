class WhittedIntegrator extends SurfaceIntegrator
  
  incidentRadiance: (scene, renderer, ray, intersection, sample, random) ->
    rad = new Spectrum(0)
    bsdf = intersection.getBSDF ray
    p = bsdf.dgShading.point
    n = bsdf.dgShading.normalisedNormal
    outgoingD = -ray.direction
    rad += intersection.emitted outgoing
    for light in scene.lights
      [incident, incidentD, pdf, visibility] = light.sampleL(p, intersection.rayEpsilon, new LightSample(random), ray.time)
      continue if incident.isBlack() or pdf is 0
      f = bsdf.f(outgoingD, incidentD)
      if not f.isBlack() and visibility.Unoccluded(scene)
        rad += f * incident * Vector.AbsDot(incidentD, n) * vidibility.Transmittance(scene, renderer, sample, rng, arena) / pdf

root = exports ? this
root.WhittedIntegrator = WhittedIntegrator