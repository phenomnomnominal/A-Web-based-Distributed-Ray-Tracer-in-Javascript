# *shape.coffee* contains the [**`Shape`**](#shape) class.
# ___

# ## <section id='shape'>Shape:</section>
# ___
# The **`Shape`** class provides a basic interface for all objects that appear in a given scene.
#
# An instance of any of the subclasses of **`Shape`** inherit the following properties from **`Shape`**:
#
# > * `objectToWorld` - A [**`Transform`**](transform.html#transform) that describes the mapping of the **`Shape`** from object-space to world-space
#
# > * `worldToObject` - A **`Transform`** that describes the mapping of the **`Shape`** from world-space to object-space
#
# > * `reverseOrientation` - A boolean that determines whether the **`Shape`**s surface normal directions should be reversed from the default
#
# > * `transformSwapsHandedness` - A boolean that indicates whether the `objectToWorld` transformation changes the 'handedness' of the **`Shape`**
#
# > * `shapeID` - A number which acts as a unique identified for the **`Shape`**. The ID's start at `1` so that `0` can be used to indicate 'no **`Shape`**'
#
#
# **`Shape`** also provides default functions for [**`worldBound`**](#wb), [**`canIntersect`**](#ci) and [**`getShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
class Shape
  # ___
  # ### *Class variables:*
  
  # > * `nextShapeID` - increments as every new **`Shape`** is Initialised
  nextShapeID = 1
  
  # ### *constructor:*
  # > The **`Shape`** constructor requires two **`Transform`**s, `objectToWorld` and `worldToObject` (which are inverses of one another).  
  #
  # > It also requires a boolean, `reverseOrientation`.  
  #
  # > If these are not supplied, the constructor will throw an **`Error`**, otherwise the remaining properties will be set.
  constructor: (@objectToWorld, @worldToObject, @reverseOrientation) ->
    unless @objectToWorld? 
      throw Error "objectToWorld must be defined."
    unless @objectToWorld.constructor.name is "Transform"
      throw Error "objectToWorld must be a Transform."
    unless @worldToObject?
      throw Error "worldToObject must be defined."
    unless @worldToObject.constructor.name is "Transform"
      throw Error "worldToObject must be a Transform."
    unless @reverseOrientation?
      throw Error "reverseOrientation must be defined."
    unless _.isBoolean(@reverseOrientation)
      throw Error "reverseOrientation must be a Boolean."
    @transformSwapsHandedness = Transform.SwapsHandedness @objectToWorld
    @shapeID = nextShapeID++
    
  # ___
  # ### Prototypical Instance Functions:
  
  # These functions are attached to each instance of the **`Shape`** class - changing the property of one **`Shape`** changes the property on all other **`Shape`**s as well.
  #
  # The **`Shape`** class provides default implementations for [**`worldBound`**](#wb), [**`canIntersect`**](#ci) and [**`getShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
    
  # ### *objectBound:*
  # > **`objectBound`** returns a [**`BoundingBox`**](geometry.html#bbox) of the **`Shape`** in the **`Shape`**'s object-space. It is required to be overridden by all subclasses of the **`Shape`** class.
  objectBound: ->
    throw Error "Not Implemented - objectBound must be implemented by Shape subclasses."
      
  # ### <section id='wb'>*worldBound:*</section>
  # > **`worldBound`** returns a **`BoundingBox`** of the **`Shape`** in the **`Shape`**'s world-space. The **`Shape`** class provides a default implementation, but it can be overridden if there is a way to compute a tighter bound.
  worldBound: ->
    return Transform.TransformBoundingBox @objectToWorld, @objectBound()
    
  # ### <section id='ci'>*canIntersect:*</section>
  # > **`canIntersect`** indicates whether a **`Shape`** can compute ray intersections. Only **`Shape`**s that are nonintersectable need to override this function.
  canIntersect: ->
    return true
    
  # ### *refine:*
  # > **`refine`** provides the functionality to split any **`Shape`** that cannot be intersected into a group of smaller **`Shape`**s (some of which may be intersectable, some may need further refinement).
  #  
  # > All **`Shape`**s that return `false` for [**`canIntersect`**](#ci) must implement this function.
  refine: ->
    throw Error "Not Implemented - refine must be implemented by Shape subclasses."
  
  # ### <section id='intersect'>*intersect:*</section>
  # > **`intersect`** returns geometric information about a single [**`Ray`**](geometry.html#ray)-**`Shape`** intersection corresponding to the first intersection (if any) along the parametric range of the **`Ray`**.  
  #
  # > All **`Shape`**s that return `true` for [**`canIntersect`**](#ci) must implement this function.
  intersect: ->
    throw Error "Not Implemented - intersect must be implemented by Shape subclasses."
  
  # ### *intersectP:*
  # > **`intersectP`** determines whether or not an intersection occurs between a **`Ray`** and a **`Shape`**, without providing any information about the intersection.  
  #
  # > All **`Shape`**s that return `true` for [**`canIntersect`**](#ci) must implement this function.
  intersectP: ->
    throw Error "Not Implemented - intersectP must be implemented by Shape subclasses."
  
  # ### *area:*
  # > **`area`** computes the surface area of a **`Shape`** in object-space.  
  #
  # > All **`Shape`**s that return `true` for [**`canIntersect`**](#ci) must implement this function.
  area: ->
    throw Error "Not Implemented - area must be implemented by Shape subclasses."
  
  # ### <section id='gsg'>*getShadingGeometry:*</section>
  # > **`getShadingGeometry`**  returns the shading geometry corresponding to the [**`DifferentialGeometry`**](differentialgeometry.html#diffgeo) returned by the [**`intersect`**](#intersect) function.
  #
  # > The default implementation just returns the true geometry, but it may be overridden by subclasses to transform the true geometry by an `objectToWorld` [**`Transform`**](transform.html#transform). This **`Transform`** will not necessarily be the same **`Transform`** defined in the `@objectToWorld` property. This allows for object instancing, where the same geometry is just transformed to a different location in world-space.
  getShadingGeometry: (objectToWorld, dg) ->
    return dg
    
# ___
# ## Exports:

# The [**`Shape`**](#shape) class is added to the global `root` object.
root = exports ? this
root.Shape = Shape