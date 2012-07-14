# *shape.coffee* contains the [**`Shape`**](#shape) class.
# ___

# ## <section id='shape'>Shape:</section>
# ___
# The **`Shape`** class provides a basic interface for all objects that appear in a given scene.
#
# An instance of any of the subclasses of **`Shape`** inherit the following properties from **`Shape`**:
#
# > * `ObjectToWorld` - A [**`Transform`**](transform.html#transform) that describes the mapping of the **`Shape`** from object-space to world-space
#
# > * `WorldToObject` - A **`Transform`** that describes the mapping of the **`Shape`** from world-space to object-space
#
# > * `ReverseOrientation` - A boolean that determines whether the **`Shape`**s surface normal directions should be reversed from the default
#
# > * `TransformSwapsHandedness` - A boolean that indicates whether the `ObjectToWorld` transformation changes the 'handedness' of the **`Shape`**
#
# > * `ShapeID` - A number which acts as a unique identified for the **`Shape`**. The ID's start at `1` so that `0` can be used to indicate 'no **`Shape`**'
#
#
# **`Shape`** also provides default functions for [**`WorldBound`**](#wb), [**`CanIntersect`**](#ci) and [**`GetShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
class Shape
  # ___
  # ### *Class variables:*
  
  # > * `nextShapeID` - increments as every new **`Shape`** is Initialised
  nextShapeID = 1
  
  # ### *constructor:*
  # > The **`Shape`** constructor requires two **`Transform`**s, `ObjectToWorld` and `WorldToObject` (which are inverses of one another).  
  #
  # > It also requires a boolean, `ReverseOrientation`.  
  #
  # > If these are not supplied, the constructor will throw an **`Error`**, otherwise the remaining properties will be set.
  constructor: (@ObjectToWorld, @WorldToObject, @ReverseOrientation) ->
    unless @ObjectToWorld? 
      throw Error "ObjectToWorld must be defined."
    unless @ObjectToWorld.constructor.name is "Transform"
      throw Error "ObjectToWorld must be a Transform."
    unless @WorldToObject?
      throw Error "WorldToObject must be defined."
    unless @WorldToObject.constructor.name is "Transform"
      throw Error "WorldToObject must be a Transform."
    unless @ReverseOrientation?
      throw Error "ReverseOrientation must be defined."
    @TransformSwapsHandedness = Transform.SwapsHandedness @ObjectToWorld
    @ShapeID = nextShapeID++
    
  # ___
  # ### Prototypical Instance Functions:
  
  # These functions are attached to each instance of the **`Shape`** class - changing the property of one **`Shape`** changes the property on all other **`Shape`**s as well.
  #
  # The **`Shape`** class provides default implementations for [**`WorldBound`**](#wb), [**`CanIntersect`**](#ci) and [**`GetShadingGeometry`**](#gsg), all other functions must be implemented and overridden by the subclasses.
    
  # ### *ObjectBound:*
  # > **`ObjectBound`** returns a [**`BoundingBox`**](geometry.html#bbox) of the **`Shape`** in the **`Shape`**'s object-space. It is required to be overridden by all subclasses of the **`Shape`** class.
  ObjectBound: ->
    throw Error "Not Implemented - ObjectBound must be implemented by Shape subclasses."
      
  # ### <section id='wb'>*WorldBound:*</section>
  # > **`WorldBound`** returns a **`BoundingBox`** of the **`Shape`** in the **`Shape`**'s world-space. The **`Shape`** class provides a default implementation, but it can be overridden if there is a way to compute a tighter bound.
  WorldBound: ->
    return Transform.TransformBoundingBox @ObjectToWorld, @ObjectBound()
    
  # ### <section id='ci'>*CanIntersect:*</section>
  # > **`CanIntersect`** inicates whether a **`Shape`** can compute ray intersections. Only **`Shape`**s that are nonintersectable need to override this function.
  CanIntersect: ->
    return true
    
  # ### *Refine:*
  # > **`Refine`** provides the functionality to split any **`Shape`** that cannot be intersected into a group of smaller **`Shape`**s (some of which may be intersectable, some may need further refinement).
  #  
  # > All **`Shape`**s that return `false` for [**`CanIntersect`**](#ci) must implement this function.
  Refine: ->
    throw Error "Not Implemented - Refine must be implemented by Shape subclasses."
  
  # ### *Intersect:*
  # > **`Intersect`** returns geometric information about a single [**`Ray`**](geometry.html#ray)-**`Shape`** intersection corresponding to the first intersection (if any) along the parametric range of the **`Ray`**.  
  #
  # > All **`Shape`**s that return `true` for [**`CanIntersect`**](#ci) must implement this function.
  Intersect: ->
    throw Error "Not Implemented - Intersect must be implemented by Shape subclasses."
  
  # ### *IntersectP:*
  # > **`IntersectP`** determines whether or not an intersection occurs between a **`Ray`** and a **`Shape`**, without providing any information about the intersection.  
  #
  # > All **`Shape`**s that return `true` for [**`CanIntersect`**](#ci) must implement this function.
  IntersectP: ->
    throw Error "Not Implemented - IntersectP must be implemented by Shape subclasses."
  
  # ### *Area:*
  # > **`Area`** computes the surface area of a **`Shape`** in object-space.  
  #
  # > All **`Shape`**s that return `true` for [**`CanIntersect`**](#ci) must implement this function.
  Area: ->
    throw Error "Not Implemented - Area must be implemented by Shape subclasses."
  
  # ### <section id='gsg'>*GetShadingGeometry:*</section>
  # > **`GetShadingGeometry`**  returns the shading geometry corresponding to the [**`DifferentialGeometry`**](differentialgeometry.html#diffgeo) returned by the *Intersect* function.
  #
  # > The default implementation just returns the true geometry, but it may be overridden by subclasses to transform the true geometry by an `objectToWorld` [**`Transform`**](transform.html#transform). This **`Transform`** will not necessarily be the same **`Transform`** defined in the `ObjectToWorld` property. This allows for object instancing, where the same geometry is just transformed to a different location in world-space.
  GetShadingGeometry: (objectToWorld, dg) ->
    return dg
    
# ___
# ## Exports:

# The **`Shape`** class is added to the global `root` object.
root = exports ? this
root.Shape = Shape