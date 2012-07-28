# *triangle.coffee* contains the [**`TriangleMesh`**](#mesh) and [**`Triangle`**](#triangle) classes.
# ___

# ## Error Types:
# Some specific **`Error`** types for these classes:
  
# <section id='tmce'></section>
#
# * **`TriangleMeshConstructorError`**:
#
# >> These errors are thrown when something is wrong in the [**`TriangleMesh`**](#mesh) constructor
class TriangleMeshConstructorError extends Error

# ## <section id='mesh'>TriangleMesh:</section>
# ___
# The **`TriangleMesh`** class is an extension of the [**`Shape`**](shape.html#shape) class that provides a way to store the data from large numbers of [**`Triangles`**](#triangle) so that their per-vertex data, such as position, normals etc. can be shared among many triangles, in order to save memory.
class TriangleMesh extends Shape
  # ### *constructor:*
  # > The **`TriangleMesh`** constructor requires the same parameters as the **`Shape`** [**`constructor`**](shape.html#shape-cons).
  #
  # > In addition, it requires several other parameters:
  #
  # > * The number of **`Triangles`** that make up the mesh: `numberTriangles`
  #
  # > * The number of vertices that make up those **`Triangles`**: `numberVertices`
  #
  # > * The `Array` of numbers which correspond to the indices of the vertices: `vertexIndices`
  #
  # > * The `Array` of vertex positions: `positions`.
  #
  # > If these are not supplied or are of the incorrect type, the constructor will throw a [**`TriangleMeshConstructorError`**](#tmce).
  # 
  # > There are also several optional arguments:
  #
  # > * An `Array` of [**`Normals`**](geometry.html#normal), used to compute shading geometry: `normals`
  #
  # > * An `Array` of [**`Vectors`**](geometry.html#vector), used to compute shading geometry: `tangents`
  #
  # > * An `Array` of parameterised (U,V) coordinates, used for intersections and texture mapping: `uvs`
  #
  # > * A Texture used to remove part of the **`Triangle`** surfaces: `alphaTexture`
  # 
  # > All the constructor arguments are copied before being stored in the **`TriangleMesh`** object. This is so that the caller retains ownership of the data that is passed in.
  constructor: (objectToWorld, worldToObject, reverseOrientation, 
                @numberTriangles, @numberVertices, vertexIndices, positions, 
                normals = [], tangents = [], uvs = [], alphaTexture = null) ->
                  
    super(objectToWorld, worldToObject, reverseOrientation)
    
    unless @numberTriangles?
      throw Error "numberTriangles must be defined."
    unless _.isNumber @numberTriangles
      throw Error "numberTriangles must be a Number."
    unless @numberVertices?
      throw Error "numberVertices must be defined."
    unless _.isNumber @numberVertices
      throw Error "numberVertices must be a Number."
    unless vertexIndices?
      throw Error "vertexIndices must be defined."
    unless _.isArray vertexIndices
      throw Error "vertexIndices must be an Array."
    unless positions?
      throw Error "positions must be defined."
    unless _.isArray positions
      throw Error "positions must be an Array."
      
    if normals?
      unless _.isArray normals
        throw Error "normals must be an Array."
    if tangents?
      unless _.isArray tangents
        throw Error "tangents must be an Array."
    if uvs?
      unless _.isArray uvs
        throw Error "uvs must be an Array."
        
    @vertexIndices = []
    for vi in vertexIndices
      @vertexIndices.push vi
    @positions = []
    for p in positions
      @positions.push Transform.TransformPoint(objectToWorld, p)
    @normals = []
    for n in normals
      @normals.push Normal.Clone(n)
    @tangents = []
    for t in tangents
      @tangents.push Vector.Clone(t)
    @uvs = []
    for uv in uvs
      @uvs.push [uv[0], uv[1]]
    `//TODO: triangleMesh.alphaTesture = AlphaTexture(alphaTexture)`
  
  # ### *objectBound:*
  # > **`objectBound`** returns a [**`BoundingBox`**](geometry.html#bbox) of the **`TriangleMesh`** in the **`TriangleMesh`**'s object-space. This is achieved by first creating an empty **`BoundingBox`**, then transforming all of the [**`Points`**](geometry.html#point) in `positions` with [**`Transform.TransformPoint`**](transform.html#transform-point) and expanding the **`BoundingBox`** to encapsulate each one using the [**`BoundingBox.UnionBBoxAndPoint`**](geometry.html#bbox-unionbp) function.
  objectBound: ->
    objectBoundingBox = new BoundingBox
    for p in @positions
      transformed = Transform.TransformPoint @worldToObject, p
      objectBoundingBox = BoundingBox.UnionBBoxAndPoint objectBoundingBox, transformed
    return objectBoundingBox
  
  # ### *worldBound:*
  # > **`worldBound`** returns a [**`BoundingBox`**](geometry.html#bbox) of the **`TriangleMesh`** in the **`TriangleMesh`**'s world-space. This is achieved by first creating an empty **`BoundingBox`** and expanding the **`BoundingBox`** to encapsulate each [**`Point`**](geometry.html#point) is `positions` using the [**`BoundingBox.UnionBBoxAndPoint`**](geometry.html#bbox-unionbp) function.
  worldBound: ->
    worldBoundingBox = new BoundingBox
    for p in @positions
      worldBoundingBox = BoundingBox.UnionBBoxAndPoint worldBoundingBox, p
    return worldBoundingBox
  
  # ### *canIntersect:*
  # > **`canIntersect`** indicates whether a **`Shape`** can compute [**`Ray`**](geometry.html#ray) intersections. Because a **`TriangleMesh`** must first be refined into a set of [**`Triangles`**](#triangle), `canIntersect` returns `no`.
  canIntersect: ->
    no
    
  # ### *refine:*
  # > **`refine`** is called whenever a [**`Shape`**](shape.html#shape) that cannot be intersected is encountered. It provides the functionality to split the **`Shape`** into a group of smaller **`Shapes`**, some of which may be intersectable, some that may need further refinement. For **`TriangleMesh`**, this involves creating an `Array` of [**`Triangles`**](#triangle).
  refine: ->
    triangles = []
    for n in [0...@numberTriangles]
      triangles.push new Triangle(@objectToWorld, @worldToObject, @reverseOrientation, this, n)
    return triangles
    
# ___

# ## <section id='triangle'>Triangle:</section>
# ___
class Triangle extends Shape
  constructor: (objectToWorld, worldToObject, reverseOrientation, triangleMesh, n) ->
                  
    super(objectToWorld, worldToObject, reverseOrientation)
    
    @mesh = triangleMesh
    @v = @mesh.vertexIndices[3*n]
    
  objectBound: ->
    p1 = Transform.TransformPoint @WorldToObject, @mesh.positions[@v]
    p2 = Transform.TransformPoint @WorldToObject, @mesh.positions[@v + 1]
    p3 = Transform.TransformPoint @WorldToObject, @mesh.positions[@v + 2]
    return BoundingBox.UnionBBoxAndPoint new BoundingBox(p1, p2), p3
    
  worldBound: ->
    p1 = @mesh.positions[@v]
    p2 = @mesh.positions[@v + 1]
    p3 = @mesh.positions[@v + 2]
    return BoundingBox.UnionBBoxAndPoint new BoundingBox(p1, p2), p3
    
  intersects: (ray) ->
    p1 = @mesh.positions[@v]
    p2 = @mesh.positions[@v + 1]
    p3 = @mesh.positions[@v + 2]
    e1 = Point.SubtractPointFromPoint p2, p1
    e2 = Point.SubtractPointFromPoint p3, p1
    s1 = Vector.Cross ray.direction, e2
    divisor = Vector.Dot s1, e1
    if divisor is 0
      return false
    invDivisor = 1 / divisor
    d = Point.SubtractPointFromPoint ray.origin, p1
    b1 = invDivisor * Vector.Dot d, s1
    if b1 < 0 or b1 > 1
      return false
    s2 = Vector.Cross d, e1
    b2 = invDivisor * Vector.Dot ray.direction, s2
    if b2 < 0 or b1 + b2 > 1
      return false
    t = invDivisor * Vector.Dot e2, s2
    if t < ray.minTime or t > ray.maxTime
      return false
    if @mesh.uvs?
      uvs = [[@mesh.uvs[2 * @v], @mesh.uvs[2 * @v + 1]],
             [@mesh.uvs[2 * (@v + 1)], @mesh.uvs[2 * (@v + 1) + 1]],
             [@mesh.uvs[2 * (@v + 2)], @mesh.uvs[2 * (@v + 2) + 1]]]
    else
      uvs = [[0, 0], [1, 0], [1, 1]]
    du1 = uvs[0][0] - uvs[2][0]
    du2 = uvs[1][0] - uvs[2][0]
    dv1 = uvs[0][1] - uvs[2][1]
    dv2 = uvs[1][1] - uvs[2][1]
    dp1 = Point.SubtractPointFromPoint p1, p3
    dp2 = Point.SubtractPointFromPoint p2, p3
    determinant = du1 * dv2 - dv1 * du2
    if determinant is 0
      [normal, dpdu, dpdv] = Vector.CoordinateSystem(Vector.Normalise(Vector.Cross(e2, e1)))
    else
      invdet = 1 / determinant
      dpdu = Vector.Multiply Vector.Subtract(Vector.Multiply(dp1, dv2), Vector.Multiply(dp2, dv1)), invdet
      dpdv = Vector.Multiply Vector.Add(Vector.Multiply(dp1, -du2), Vector.Multiply(dp2, du1)), invdet
    b0 = 1 - b1 - b2
    tu = b0 * uvs[0][0] + b1 * uvs[1][0] + b2 * uvs[2][0]
    tv = b0 * uvs[0][1] + b1 * uvs[1][1] * b2 * uvs[2][1]
    `// TODO if @mesh.alphaTexture`
    dg = new DifferentialGeometry(ray.getPoint(t), dpdu, dpdv, new Normal(0, 0, 0), new Normal(0, 0, 0), tu, tv, this)
    return [true, t, 1e-3 * t, dg]
    
    area = ->
      p1 = @mesh.positions[@v]
      p2 = @mesh.positions[@v + 1]
      p3 = @mesh.positions[@v + 2]
      cross = Vector.Cross Point.SubtractPointFromPoint(p2, p1), Point.SubtractPointFromPoint(p3, p1)
      return 0.5 * Math.sqrt(cross.x * cross.x + cross.y * cross.y + cross.z * cross.z)
      
    getShadingGeoemtry = (objectToWorld, dg) ->
      if not @mesh.normals? and not @mesh.tangents?
        return dg
      if @mesh.uvs?
        uvs = [[@mesh.uvs[2 * @v], @mesh.uvs[2 * @v + 1]],
               [@mesh.uvs[2 * (@v + 1)], @mesh.uvs[2 * (@v + 1) + 1]],
               [@mesh.uvs[2 * (@v + 2)], @mesh.uvs[2 * (@v + 2) + 1]]]
      else
        uvs = [[0, 0], [1, 0], [1, 1]]
      A = [[uvs[1][0] - uvs[0][0], uvs[2][0] - uvs[0][0]],[uvs[1][1] - uvs[0][1], uv[2][1] - uvs[0][1]]]
      C = [dg.u - uvs[0][0], dg.v - uvs[0][1]]
      [solved, b1, b2] = MathFunctions.SolveLienarSystem2x2(A, C)
      if not solved
        b0 = b1 = b2 = 1 / 3
      else
        b0 = 1 - b1 - b2
      if @mesh.normals?
        nv1 = Normal.Multiply(@mesh.normals[@v], b0)
        nv2 = Normal.Multiply(@mesh.normals[@v + 1], b1)
        nv3 = Normal.Multiply(@mesh.normals[@v + 2], b2)
        n = Normal.Add Normal.Add(nv1, nv2), nv3
        ns = Normal.Normalise Transform.TransformNormal(n)
      else 
        ns = dg.nn
      if @mesh.tangents?
        tv1 = Vector.Multiply @mesh.tangents[@v], b0
        tv2 = Vector.Multiply @mesh.tangents[@v + 1], b1
        tv3 = Vector.Multiply @mesh.tangents[@v + 2], b2
        v = Vector.Add Vector.Add(tv1, tv2), tv3
        ss = Vector.Normalise Transform.TransformVector(v)
      else 
        ss = Vector.Normalise dg.dpdu
      ts = Vector.Cross ss, ns
      if (ts.x * ts.x + ts.y * ts.y + ts.z * ts.z) > 0
        ts = Vector.Normalise ts
        ss = Vector.Cross ts, ns
      else
        [ns, ss, ts] = Vector.CoordinateSystem ns
      if @mesh.normals
        if @mesh.uvs?
          uvs = [[@mesh.uvs[2 * @v], @mesh.uvs[2 * @v + 1]],
                 [@mesh.uvs[2 * (@v + 1)], @mesh.uvs[2 * (@v + 1) + 1]],
                 [@mesh.uvs[2 * (@v + 2)], @mesh.uvs[2 * (@v + 2) + 1]]]
        else
          uvs = [[0, 0], [1, 0], [1, 1]]
        du1 = uvs[0][0] - uvs[2][0]
        du2 = uvs[1][0] - uvs[2][0]
        dv1 = uvs[0][1] - uvs[2][1]
        dv2 = uvs[1][1] - uvs[2][1]
        dn1 = Normal.Subtract @mesh.normals[v], mesh.normals[v + 2]
        dn2 = Normal.Subtract @mesh.normals[v + 1], mesh.normals[v + 2]
        determinant = du1 * dv2 - dv1 * du2;
        if determinant is 0
          dndu = dndv = new Normal(0,0,0);
        else 
          invdet = 1.f / determinant;
          dndu = Normal.Subtract(dn1.multiply(dv2), dn2.multiply(dv1)).multiply(invdet)
          dndv = Normal.Subtract(dn1.multiply(-du2), dn2.multiply(du1)).multiply(invdet)
      else
        dndu = dndv = new Normal(0,0,0)
      dgShading = new DifferentialGeometry(dg.p, ss, ts,
          Transform.TransformNormal(objectToWorld, dndu), Transform.TransformNormal(objectToWorld, dndv),
          dg.u, dg.v, dg.shape);
      dgShading.dudx = dg.dudx;  dgShading.dvdx = dg.dvdx
      dgShading.dudy = dg.dudy;  dgShading.dvdy = dg.dvdy
      dgShading.dpdx = dg.dpdx;  dgShading.dpdy = dg.dpdy
      return dgShading
      
# ___
# ## Exports:

# The [**`TriangleMesh`**](#triangleMesh) and [**`Triangle`**](#triangle) classes are added to the global `root` object.
root = exports ? this
root.TriangleMesh = TriangleMesh
root.Triangle = Triangle