# *differentialGeometry.coffee* contains the **`DifferentialGeometry`** class.
# ___

# ## Error Types:
# Some specific **`Error`** types for these classes:

# <section id='dgce'></section>
#
# * **`DiffGeoConstructorError`**:
#
# >> These errors are thrown when something is wrong in the [**`DifferentialGeometry`**](#diffgeo) constructor
class DiffGeoConstructorError extends Error

# ___

# ## <section id='diffgeo'>DifferentialGeometry:</section>
# ___
#
# The **`DifferentialGeometry`** structure provides a self-contained representation for the geometry of a particular point on a surface.
# It contains:
#
# * The 3D representation of the point
#
# * The surface normal at the point
#
# * *(u, v)* coordinates from the parameterisation of the surface
#
# * The parametric partial derivatives *&part;p &frasl; &part;u* and *&part;p &frasl; &part;v*
#
# * The partial derivatives of the change in surface normal *&part;n &frasl; &part;u* and *&part;n &frasl; &part;v*
#
# * A reference to the [**`Shape`**](shape.html) that the differential geometry lies on
class DifferentialGeometry
  # ### *constructor:*
  # > The **`DifferentialGeometry`** constructor takes several parameters:
  #
  # > * The [**`Point`**](geometry.html#point) of interest: `point`
  #
  # > * The partial derivatives of position and normal: `dpdu`, `dpdv`, `dndu` and `dndv`
  #
  # > * The *(u, v)* coordinates: `u` and `v` - defaults to 0
  #
  # > * The [**`Shape`**](shape.html#shape) it belongs to: `shape` - defaults to null
  # 
  # > If these are not supplied or are of the incorrect type, the constructor
  # will throw an **`Error`**.
  constructor: (@point, @dpdu, @dpdv, @dndu, @dndv, @u = 0, @v = 0, @shape = null) ->
    
    unless @point?
      throw DiffGeoConstructorError 'point must be defined.'
    unless @point instanceof Point
      throw DiffGeoConstructorError 'point must be a Point.'
    unless @dpdu?
      throw DiffGeoConstructorError 'dpdu must be defined.'
    unless @dpdu instanceof Vector
      throw DiffGeoConstructorError 'dpdu must be a Vector.'
    unless @dpdv?
      throw DiffGeoConstructorError 'dpdv must be defined.'
    unless @dpdv instanceof Vector
      throw DiffGeoConstructorError 'dpdv must be a Vector.'
    unless @dndu?
      throw DiffGeoConstructorError 'dndu must be defined.'
    unless @dndu instanceof Normal
      throw DiffGeoConstructorError 'dndu must be a Normal.'
    unless @dndv?
      throw DiffGeoConstructorError 'dndv must be defined.'
    unless @dndv instanceof Normal
      throw DiffGeoConstructorError 'dndv must be a Normal.'
    
    unless _.isNumber @u
      throw DiffGeoConstructorError 'u must be a Number.'
    unless _.isNumber @v
      throw DiffGeoConstructorError 'v must be a Number.'
      
    if @shape?
      unless @shape instanceof Shape
        throw Error 'shape must be a Shape.'
    
    @dudx = 0
    @dvdx = 0
    @dudy = 0
    @dvdy = 0
        
    # > The [**`Normal`**](geometry.html#normal) is computed as the [**Cross Product**](http://en.wikipedia.org/wiki/Cross_product) of the partial derivatives.
    @normalisedNormal = Normal.FromVector Vector.Normalise(Vector.Cross(@dpdu, @dpdv))

    # > If the **`Shape`** has the `ReverseOrientation` flag set, or its transformation matrix swaps the handesness of the coordinate system, the normal is flipped so it stays on the "outside" of the **`Shape`**. However, if both of these are true then the effect is cancelled out, so the exclusive-OR (`^`) operator is used.
    if @shape? and (@shape.reverseOrientation ^ @shape.transformSwapsHandedness)
      @normalisedNormal.multiply -1

# ___
# ## Exports:

# The [**`DifferentialGeometry`**](#diffgeo) class is added to the global `root` object.
root = exports ? this
root.DifferentialGeometry = DifferentialGeometry