# *shape.coffee* contains the [**`Shape`**](#shape) class.
# ___

# ## Error Types:
# Some specific **`Error`** types for these classes:
  
# <section id='sce'></section>
#
# * **`ShapeConstructorError`**:
#
# >> These errors are thrown when something is wrong in the [**`Shape`**](#shape) constructor
class ShapeConstructorError extends Error
  
# <section id='mboe'></section>
#
# * **`MustBeOverriddenError`**:
#
# >> These errors are thrown when a function is required to be overridden by a subclass of [**`Shape`**](#shape)
class MustBeOverriddenError extends Error

# ___

# ## <section id='shape'>Shape:</section>
# ___
# **`Shape`** is an abstract bass class that defines an interface for all objects that appear in a given scene.
#
# **`Shape`** also provides default functions for [**`worldBound`**](#wb), [**`canIntersect`**](#ci) and [**`getShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
class Shape
  # ___
  # ### *Class variables:*
  
  # * `nextShapeID` - increments as each new **`Shape`** is Initialised
  nextShapeID = 1
  
  # ### <section id='shape-cons'>*constructor:*</section>
  # > The **`Shape`** constructor requires three parameters that are appropriate for all **`Shape`** types:
  #
  # > * An object-space to world-space transformation: `objectToWorld` - must be a [**`Transform`**](transform.html#transform)
  #
  # > * A world-space to object-space transformation: `worldToObject` - must be a [**`Transform`**](transform.html#transform)
  #
  # > * A boolean that indicates whether the **`Shapes`** surface normal directions should be reversed: `reverseOrientation`
  #
  # > If these are not supplied or are of the incorrect type, the constructor will throw a **`ShapeConstructorError`**.
  #
  # > Additional properties are assigned by the constructor:
  #
  # > * A boolean that indicates whether the `objectToWorld` transformation changes the 'handedness' of the **`Shape`**: `transformSwapsHandedness`
  #
  # > * An unique ID number for the **`Shape`**: `shapeID`
  constructor: (@objectToWorld, @worldToObject, @reverseOrientation) ->
    unless @objectToWorld? 
      throw ShapeConstructorError "objectToWorld must be defined."
    unless @objectToWorld instanceof Transform
      throw ShapeConstructorError "objectToWorld must be a Transform."
    unless @worldToObject?
      throw ShapeConstructorError "worldToObject must be defined."
    unless @worldToObject instanceof Transform
      throw ShapeConstructorError "worldToObject must be a Transform."
    unless @reverseOrientation?
      throw ShapeConstructorError "reverseOrientation must be defined."
    unless _.isBoolean @reverseOrientation
      throw ShapeConstructorError "reverseOrientation must be a Boolean."
      
    @transformSwapsHandedness = Transform.SwapsHandedness @objectToWorld
    @shapeID = nextShapeID++
    
  # ___
  # ### Prototypical Instance Functions:
  
  # These functions are attached to each instance of the **`Shape`** class - changing the property of one **`Shape`** changes the property on all other **`Shapes`** as well.
  #
  # The **`Shape`** class provides default implementations for [**`worldBound`**](#wb), [**`canIntersect`**](#ci) and [**`getShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
    
  # ### *objectBound:*
  # > **`objectBound`** returns a [**`BoundingBox`**](geometry.html#bbox) of the **`Shape`** in its object-space. It is required to be overridden by all subclasses of the **`Shape`** class.
  objectBound: ->
    throw MustBeOverriddenError 'objectBound must be implemented by Shape subclasses.'
      
  # ### <section id='wb'>*worldBound:*</section>
  # > **`worldBound`** returns a **`BoundingBox`** of the **`Shape`** in its world-space. The **`Shape`** class provides a default implementation, but it can be overridden if there is a way to compute a tighter bound.
  worldBound: ->
    return Transform.TransformBoundingBox @objectToWorld, @objectBound()
    
  # ### <section id='ci'>*canIntersect:*</section>
  # > **`canIntersect`** indicates whether a **`Shape`** can compute [**`Ray`**](geometry.html#ray) intersections. Only **`Shapes`** that are not intersectable need to override this function.
  canIntersect: ->
    yes
    
  # ### *refine:*
  # > **`refine`** provides the functionality to split any **`Shape`** that cannot be intersected into a group of smaller **`Shapes`** (some of which may be intersectable, some may need further refinement).
  #  
  # > All **`Shapes`** that return `no` for [**`canIntersect`**](#ci) must implement this function.
  refine: ->
    throw MustBeOverriddenError 'refine must be implemented by Shape subclasses.'
  
  # ### <section id='intersect'>*intersect:*</section>
  # > **`intersect`** returns geometric information about a single [**`Ray`**](geometry.html#ray)-**`Shape`** intersection corresponding to the first intersection (if any) along the parametric range of the **`Ray`**.  
  #
  # > All **`Shapes`** that return `yes` for [**`canIntersect`**](#ci) must implement this function.
  intersect: ->
    throw MustBeOverriddenError 'intersect must be implemented by Shape subclasses.'
  
  # ### *intersectP:*
  # > **`intersectP`** determines whether or not an intersection occurs between a **`Ray`** and a **`Shape`**, without providing any information about the intersection.  
  #
  # > All **`Shapes`** that return `yes` for [**`canIntersect`**](#ci) must implement this function.
  intersectP: ->
    throw MustBeOverriddenError 'intersectP must be implemented by Shape subclasses.'
  
  # ### *area:*
  # > **`area`** computes the surface area of a **`Shape`** in object-space.  
  #
  # > All **`Shapes`** that return `yes` for [**`canIntersect`**](#ci) must implement this function.
  area: ->
    throw MustBeOverriddenError 'area must be implemented by Shape subclasses.'
  
  # ### <section id='gsg'>*getShadingGeometry:*</section>
  # > **`getShadingGeometry`**  returns the shading geometry corresponding to the [**`DifferentialGeometry`**](differentialgeometry.html#diffgeo) returned by the [**`intersect`**](#intersect) function.
  #
  # > The default implementation returns the true geometry, but it may be overridden by subclasses to transform the true geometry by an `objectToWorld` [**`Transform`**](transform.html#transform). This **`Transform`** will not necessarily be the same **`Transform`** defined in the `@objectToWorld` property. This allows for object instancing, where the same geometry is just transformed to a different location in world-space.
  getShadingGeometry: (objectToWorld, dg) ->
    return dg

class ShapeSet
  constructor: (@shapes) ->
    
# ___
# ## Exports:

# The [**`Shape`**](#shape) class is added to the global `root` object.
root = exports ? this
root.Shape = Shape