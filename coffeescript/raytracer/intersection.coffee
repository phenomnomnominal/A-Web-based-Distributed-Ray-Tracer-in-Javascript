# *intersection.coffee* contains the [**`Intersection`**](#intersection) class.
# ___

# ## Error Types:
# Some specific **`Error`** types for these classes:
  
# <section id='ice'></section>
#
# * **`IntersectionConstructorError`**:
#
# >> These errors are thrown when something is wrong in the [**`Intersection`**](#intersection) constructor
class IntersectionConstructorError extends Error

# ___

# ## <section id='intersection'>Intersection:</section>
# ___
# The **`Intersection`** class provides a representation of a [**`Ray`**](geometry.html#ray)-[**`Primitive`**](primitive.html#primitive) intersection.
class Intersection
  constructor: (@primitive, @worldToObject, @objectToWorld, @shapeID, @primitiveID, @rayEpsilon, @dg) ->
    unless @primitive?
      throw IntersectionConstructorError 'primitive must be defined.'
    unless @primitive instanceof Primitive
      throw IntersectionConstructorError 'primitive must be a Primitive.'
    unless @worldToObject?
      throw IntersectionConstructorError 'worldToObject must be defined.'
    unless @worldToObject instanceof Transform
      throw IntersectionConstructorError 'worldToObject must be a Transform.'
    unless @objectToWorld?
      throw IntersectionConstructorError 'objectToWorld must be defined.'
    unless @objectToWorld instanceof Transform
      throw IntersectionConstructorError 'objectToWorld must be a Transform.'
    unless @shapeID?
      throw IntersectionConstructorError 'shapeID must be defined.'
    unless _.isNumber @shapeID
      throw IntersectionConstructorError 'shapeID must be a Number.'
    unless @primitiveID?
      throw IntersectionConstructorError 'primitiveID must be defined.'
    unless _.isNumber @primitiveID
      throw IntersectionConstructorError 'primitiveID must be a Number.'
    unless @rayEpsilon?
      throw IntersectionConstructorError 'rayEpsilon must be defined.'
    unless _.isNumber @rayEpsilon
      throw IntersectionConstructorError 'rayEpsilon must be a Number.'
    unless @dg?
      throw IntersectionConstructorError 'dg must be defined.'
    unless @dg instanceof DifferentialGeometry
      throw IntersectionConstructorError 'dg must be a DifferentialGeometry.'
      
  getBSDF = (ray) ->
    @dg.computeDifferentials ray
    return @primitive.getBSDF @dg, @objectToWorld
    
  getBSSRDF = (ray) ->
    @dg.computeDifferentials ray
    return @primitive.getBSSRDF @dg, @objectToWorld
    
  emitted: (direction) ->
    area = @primitive.getAreaLight()
    return if area? then area.radiance(@dg.point, @dg.normalisedNormal, direction) else new Spectrum(0)

# ___
# ## Exports:

# The [**`Intersection`**](#intersection) class is added to the global `root` object.
root = exports ? this
root.Intersection = Intersection