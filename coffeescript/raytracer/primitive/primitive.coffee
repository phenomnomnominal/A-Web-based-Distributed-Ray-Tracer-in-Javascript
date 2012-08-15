class MustBeOverriddenError extends Error
  
class ShouldntBeCalledError extends Error

class GeometricPrimitiveConstructorError extends Error
  
class TransformedPrimitiveConstructorError extends Error

class Primitive
  nextPrimitiveID = 1
  
  constructor: ->
    @primitiveID = nextPrimitiveID++
    
  worldBound: ->
    throw MustBeOverridenError 'worldBound must be implemented by Primitive subclasses.'
      
  canIntersect: ->
    yes
    
  intersect: ->
    throw MustBeOverridenError 'intersect must be implemented by Primitive subclasses.'
    
  intersectP: ->
    throw MustBeOverridenError 'intersectP must be implemented by Primitive subclasses.'
    
  refine: ->
    throw MustBeOverridenError 'refine must be implemented by Primitive subclasses.'
          
  fullyRefine: ->
    toRefine = [this]
    refined = []
    while toRefine.length > 0
      next = toRefine.shift()
      if next.canIntersect()
        refined.concat next
      else
        toRefine.concat next.refine()
    
    
  getAreaLight: ->
    throw MustBeOverridenError 'getAreaLight must be implemented by Primitive subclasses.'
      
  getBSDF: ->
    throw MustBeOverridenError 'getBSDF must be implemented by Primitive subclasses.'
    
  getBSSRDF: ->
    throw MustBeOverridenError 'getBSSRDF must be implemented by Primitive subclasses.'
    
class GeometricPrimitive extends Primitive
  constructor: (@shape, @material, @areaLight) ->
    super()
    
    unless @shape?
      throw GeometricPrimitveConstructorError '`shape` must be defined.'
    unless @shape instanceof Shape
      throw GeometricPrimitveConstructorError '`shape` must be a Shape'
    unless @material?
      throw GeometricPrimitveConstructorError '`material` must be defined.'
    unless @material instanceof Material
      throw GeometricPrimitveConstructorError '`material` must be a Material.'
    unless @areaLight?
      throw GeometricPrimitveConstructorError '`areaLight` must be defined.'
    unless @areaLight instanceof Light
      throw GeometricPrimitveConstructorError '`areaLight` must be a Light.'
 
  worldBound: ->
    @shape.worldBound()
    
  canIntersect: ->
    @shape.canIntersect()

  refine: ->
    refined = @shape.refine()
    (new GeometricPrimitive(shape, @material, @areaLight) for shape in refined)  
    
  intersect: (r) ->
    [intersects, thit, rayEpsilion, dg] = @shape.intersect r
    if not intersects then return no
    r.maxt = thit
    intersection = new Intersection(this, @shape.worldToObject, @shape.objectToWorld, @shape.shapeID, @primitiveID, rayEpsilon, dg)
    [yes, intersection, r]
    
  intersectP: (r) ->
    @shape.intersectP r

  getAreaLight: ->
    areaLight
    
  getBSDF: (objectToWorld, dg) ->
    dgs = @shape.getShadingGeometry objectToWorld, dg
    material.getBSDF dg, dgs
    
  getBSSRDF: (objectToWorld, dg) ->
    dgs = @shape.getShadingGeometry objectToWorld, dg
    material.getBSSRDF dg, dgs

class TransformedPrimitive extends Primitive
  constructor: (@primitive, @worldToPrimitive) ->
    super()
    
    unless @primitive?
      throw TransformedPrimitiveConstructorError '`primitive` must be defined.'
    unless @primitive instanceof Primitive
      throw TransformedPrimitiveConstructorError '`primitive` must be a Primitive.'
    unless @worldToPrimitive?
      throw TransformedPrimitiveConstructorError '`worldToPrimitive` must be defined.'
    unless @worldToPrimitive instanceof AnimatedTransform
      throw TransformedPrimitiveConstructorError '`worldToPrimitive` must be an AnimatedTransform.'
  
  worldBound: ->
    AnimatedTransform.MotionBounds(@worldToPrimitive, @primitive.worldBound(), true)
  
  intersect: (r) ->
    w2p = AnimatedTransform.Interpolate(@worldToPrimitive, r.time)
    ray = Transform.TransformRay w2p, r
    [intersects, intersection, r] = @primitive.intersect ray
    if not intersects then return no
    r.maxt = ray.maxt
    intersection.primitiveID = @primitiveID
    if not Transform.IsIdentity w2d
      intersection.worldToObject.multiply w2p
      intersection.objectToWorld = Transform.InverseTransform intersection.worldToObject
      p2w = Transform.InverseTransform w2p
      dg = intersection.dg
      dg.point = Transform.TransformPoint(p2w, dg.point)
      dg.normalisedNormal = Normal.Normalise(Transform.TransformNormal(p2w, dg.normalisedNormal))
      dg.dpdu = Transform.TransformVector(p2w, dg.dpdu)
      dg.dpdv = Transform.TransformVector(p2w, dg.dpdv)
      dg.dndu = Transform.TransformNormal(p2w, dg.dndu)
      dg.dndv = Transform.TransformNormal(p2w, dg.dndv)
    [yes, intersection, r]
    
  intersectP: (r) ->
    @primitive.intersectP(Transform.TransformRay(@worldToPrimitive, r))
    
  getAreaLight: ->
    throw ShouldntBeCalledError '`TransformedPrimitive.getAreaLight` should never be called.'
    
  getBSDF: ->
    throw ShouldntBeCalledError '`TransformedPrimitive.getBSDF` should never be called.'
    
  getBSSRDF: ->    
    throw ShouldntBeCalledError '`TransformedPrimitive.getBSSRDF` should never be called.'
    
class Aggregate extends Primitive
  constructor: ->
    super()
  
  getAreaLight: ->
    throw ShouldntBeCalledError '`Aggregate.getAreaLight` should never be called.'
    
  getBSDF: ->
    throw ShouldntBeCalledError '`Aggregate.getBSDF` should never be called.'
    
  getBSSRDF: ->    
    throw ShouldntBeCalledError '`Aggregate.getBSSRDF` should never be called.'
  
root = exports ? this
root.GeometricPrimitive = GeometricPrimitive
root.TransformedPrimitive = TransformedPrimitive