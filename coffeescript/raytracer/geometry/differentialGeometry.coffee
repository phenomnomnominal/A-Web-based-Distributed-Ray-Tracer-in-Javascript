# *differentialGeometry.coffee* contains the **`DifferentialGeometry`** class.

# ## <section id='diffgeo'>DifferentialGeometry:</section>
#
# The **`DifferentialGeometry`** structure provides a self-contained representation for the geometry of a particular point on a surface.
# It contains:
#
# * The contains of the 3D point
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
# ___
class DifferentialGeometry
  # ### *constructor:*
  # > The **`DifferentialGeometry`** constructor takes several parameters:
  #
  # > * The point of interest: `point`
  #
  # > * The partial derivatives of position and normal: `dpdu`, `dpdv`, `dndu` and `dndv`
  #
  # > * The *(u, v)* coordinates: `u` and `v`
  #
  # > * The [**`Shape`**](shape.html#shape) it belongs to: `shape`
  # 
  # > The normal is computed as the [**Cross Product**](http://en.wikipedia.org/wiki/Cross_product) of the partial derivatives.
  #
  # > If the **`Shape`** has the `ReverseOrientation` flag set, or its transformation matrix swaps the handesness of the coordinate system, the normal is flipped so it stays on the "outside" of the **`Shape`**. However, if both of these are true then the effect is cancelled out, so the exclusive-OR (`^`) operator is used.
  constructor: (@point, @dpdu, @dpdv, @dndu, @dndv, @u = 0, @v = 0, @shape = null) ->
    if @dpdu? and @dpdv?
      @normalisedNormal = Normal.FromVector Vector.Normalise(Vector.Cross(@dpdu, @dpdv))
    if @shape? and (@shape.ReverseOrientation ^ @shape.TransformSwapsHandedness)
      @normalisedNormal.multiply -1

# ___
# ## Exports:

# The **`DifferentialGeometry`** class is added to the global `root` object.
root = exports ? this
root.DifferentialGeometry = DifferentialGeometry