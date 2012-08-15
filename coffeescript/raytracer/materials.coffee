class BSDF
  constructor: (@diffGeometry, @normalGeometry, @η) ->
    @nn = @diffGeometry.normalisedNormal
    @sn = Vector.Normalise @diffGeometry.dpdu
    @tn = Vector.Cross nn, sn
    @numberBxDFs = 0
    @BxDFs = []
    
  addBxDF: (BxDF) ->
    MAX_BxDFs = 8
    if @numberBxDFs < MAX_BxDFs
      @BxDFs.push BxDF
      
  numComponentsOfType: ->
    
  worldToLocal: (v) ->
    new Vector(Vector.Dot(v, @sn), Vector.Dot(v, @tn), Vector.Dot(v, @nn))
    
  localToWorld: (v) ->
    x = @sn.x * v.x + @tn.x * v.y + @nn.x * v.z
    y = @sn.y * v.x + @tn.y * v.y + @nn.y * v.z
    z = @sn.z * v.x + @tn.z * v.y + @nn.z * v.z
    new Vector(x, y, z)
    
  f: (woW, wiW, flags) ->
    wi = worldToLocal wiW
    wo = worldToLocal woW
    if Vector.Dot(wiW, @normalGeometry) * Vector.Dot(woW, @normalGeometry)
      flags = flags & -BxDF.BSDF_TYPE.TRANSMISSION
    else
      flags = flags & - BxDF.BSDF_TYPE.REFLECTION
    f = new Spectrum(0)
    for i in [0...@numberBxDFs]
      if @BxDFs[i].matchesFlags flags
        f.add @BxDFs[i].f wo, wi
    f
    
class Material
  
  getBSDF: ->
    
  getBSSRDF: ->
    null
    
class MatteMaterial extends Material
  constructor: (@diffuseReflection, @σ, @bumpMap) ->
    
  getBSDF: (dgGeom, dgShading) ->
    if bumpMap?
      diffGeoShading = Bump bumpMap, dgGeom, dgShading
    else
      diffGeoShading = dgShading
    bsdf = new BSDF(diffGeoShading, dgGeom.normalisedNormal)
    r = @diffuseReflection.evaluate(diffGeoShading).Clamp()
    σ = MathFunctions.Clamp(@σ.evaluate(diffGeoShading), 0, 90)
    if σ is 0
      bsdf.addBxDF new Lamertian(r)
    else
      bsdf.addBxDF new OrenNayar(r, σ)

class PlasticMaterial extends Material
  constructor: (@diffuseReflection, @specularReflection, @roughness, @bumpMap) ->
    
  getBSDF: (dgGeom, dgShading) ->
    if bumpMap?
      diffGeoShading = Bump bumpMap, dgGeom, dgShading
    else
      diffGeoShading = dgShading
    bsdf = new BSDF(diffGeoShading, dgGeom.normalisedNormal)
    kd = @diffuseReflection.evaluate(diffGeoShading).Clamp()
    diffuse = new Lambertian(@diffuseReflection)
    frensal = new FresnalDielectric(1.5, 1)
    ks = @specularReflection.evaluate(diffGeoShading).Clamp()
    rough = @roughness.evaluate(diffGeoShading)
    specular = new MicroFacet(ks, frensal, new Blinn(1 / rough))
    bsdf.addBxDF diffuse
    bsdf.addBxDF specular
    bsdf