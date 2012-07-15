# *matrix.coffee* contains the [**`Transform`**](#transform) class.
# ___

# ## Requires:
# Classes in *transform.coffee* require access to classes from other packages and files:

# * From [*utils/mathfunctions.coffee:*](math.html)

# > * [**MathFunctions**](math.html#math)
MathFunctions = this.MathFunctions ? if require? then require("../utils/math").MathFunctions

# * From [*geometry/geometry.coffee:*](geometry.html)
Geometry = this.Geometry ? if require? then require("./geometry")

# > * [**`Vector`**](geometry.html#vector)
Vector = this.Vector ? Geometry.Vector

# > * [**`Point`**](geometry.html#point)
Point = this.Point ? Geometry.Point

# > * [**`Normal`**](geometry.html#normal)
Normal = this.Normal ? Geometry.Normal

# > * [**`BoundingBox`**](geometry.html#bbox)
BoundingBox = this.BoundingBox ? Geometry.BoundingBox

# * From [*geometry/matrix.coffee:*](matrix.html)

# > * [**`Matrix4x4`**](matrix.html#matrix)
Matrix4x4 = this.Matrix4x4 ? if require? then require("./matrix").Matrix4x4

# ___

# ## <section id='transform'>Transform:</section>
# ___
# A **`Transform`** represents a mapping from **`Point`**s to **`Point`**s and from **`Vector`**s to **`Vector`**s in 3-dimensional space using 4-dimensional [**Homogenous Coordinates**](http://en.wikipedia.org/wiki/Homogeneous_coordinates).
class Transform
  # ### *constructor:*
  # > The **`Transform`** constructor function is defined for creating a new **`Transform`** from up totwo transformation [**`Matrix4x4`**](matrix.html#matrix)s.
  # > If two matrices are passed, these are taken as being the transformation matrix, and its inverse.
  #
  # > If only one matrix is passed, its inverse is calculated using the [**`Matrix4x4.Inverse`**](matrix.html#matrix-inverse) function.
  #
  # > If no transformation matrices are passed, a default **`Transform`** is initialised with both `matrix` and `inverse` being declared as the identity matrix:  
  # >> `[1, 0, 0, 0]`  
  # >> `[0, 1, 0, 0]`  
  # >> `[0, 0, 1, 0]`  
  # >> `[0, 0, 0, 1]`
  constructor: (matrix, inverse) ->
    if not matrix? and not inverse?
      @matrix = new Matrix4x4()
      @inverse = new Matrix4x4()
      
    else if not matrix?
      @matrix = Matrix4x4.Inverse inverse
      @inverse = inverse
    else if not inverse?
      @matrix = matrix
      @inverse = Matrix4x4.Inverse matrix
      
    else
      @matrix = matrix
      @inverse = inverse
      
  # ___  
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`Transform`** class - changing the function of one **`Transform`** changes the function on all other **`Transform`**s as well. These functions act on a **`Transform`** instance in place - the original object is modified.
        
  # ### *equals:*
  # > **`equals`** checks a **`Transform`** for equality with another **`Transform`**. Two **`Transform`**s are equal if each of their `matrix` and `inverse` components are the same.    
  equals: (t) ->
    if t.constructor? and t.constructor.name is "Transform"
      return Matrix4x4.Equals(@matrix, t.matrix) and Matrix4x4.Equals(@inverse, t.inverse)
    return false
  
  # ### *hasScale:*
  # > **`hasScale`** checks whether a **`Transform`** instance has a significant scaling factor in it.
  hasScale: ->
    a = Transform.TransformVector this, new Vector(1,0,0)
    b = Transform.TransformVector this, new Vector(0,1,0)
    c = Transform.TransformVector this, new Vector(0,0,1)
    la = Math.sqrt a.x * a.x + a.y * a.y + a.z * a.z
    lb = Math.sqrt b.x * b.x + b.y * b.y + b.z * b.z
    lc = Math.sqrt c.x * c.x + c.y * c.y + c.z * c.z
    return not ((0.999 < la < 1.001) and (0.999 < lb < 1.001) and (0.999 < lc < 1.001))
        
  # ___  
  # ### Static Functions:

  # These functions belong to the **Transform** class - any object arguments are not 
  # modified and a new object is always returned.
  
  # ### *Transform.InverseTransform:*
  # > **`Transform.InverseTransform`** returns the inverse transformation of a given **`Transform`**. Because a **`Transform`** contains both the transformation matrix and its inverse, it is simply a matter of swapping the two around.  
  @InverseTransform: (transform) ->
    return new Transform(transform.inverse, transform.matrix)
  
  # ### *Transform.Equals:*
  # > **`Transform.Equals`** checks if two **`Transform`** instances are equal to one another. Two **`Transform`**s are equal if each of their `matrix` and `inverse` components are the same.    
  @Equals: (t1, t2) ->
    if t1.constructor? and t1.constructor.name is "Transform" and t2.constructor? and t2.constructor.name is "Transform"
      return Matrix4x4.Equals(t1.matrix, t2.matrix) and Matrix4x4.Equals(t1.inverse, t2.inverse)
    return false
  
  # ### *Transform.IsIdentity:*
  # > **`Transform.IsIdentity`** checks if a given **`Transform`** is the Identity matrix:
  # >> `[1, 0, 0, 0]`  
  # >> `[0, 1, 0, 0]`  
  # >> `[0, 0, 1, 0]`  
  # >> `[0, 0, 0, 1]`
  @IsIdentity: (t) ->
    return Matrix4x4.IsIdentity(t.matrix) and Matrix4x4.IsIdentity(t.inverse)
    
  # ### *Transform.Multiply:*
  # > **`Transform.Multiply`** multiplies two **`Transform`**s into a single **`Transform`** which performs the same transformation as the two would. 
  #
  # > Care must be taken with the order in which the multiplications are performed as unexpected results can occur.
  @Multiply: (t1, t2) ->
    matrixMul = Matrix4x4.Multiply t1.matrix, t2.matrix
    inverseMul = Matrix4x4.Multiply t2.inverse, t1.inverse
    return new Transform(matrixMul, inverseMul)

  # ### *Transform.SwapsHandedness:*
  # > **`Transform.SwapsHandedness`** determines whether a **`Transform`** changes the handedness (Left to Right or vice versa) of the source coordinate system.
  @SwapsHandedness: (t) ->
    m = t.matrix.m
    det = ((m[0][0] * 
               (m[1][1] * m[2][2] - m[1][2] * m[2][1])) - 
           (m[0][1] * 
               (m[1][0] * m[2][2] - m[1][2] * m[2][0])) + 
           (m[0][2] * 
               (m[1][0] * m[2][1] - m[1][1] * m[2][0])))
    return det < 0
  
  # ___
  # ### **Common transformations:**
  
  # These functions are static implementations which generate some common transformation instances, such as Translations, Rotations and Scaling transforms.
  
  # ### *Transform.Translate:*
  # > **`Transform.Translate`** creates a **`Transform`** that performs a translation by a given [**`Vector`**](geometry.html#vector).
  @Translate: (delta) ->
    matrix = [[1, 0, 0, delta.x], 
              [0, 1, 0, delta.y],
              [0, 0, 1, delta.z],
              [0, 0, 0,       1]]
    inverse = [[1, 0, 0, -delta.x], 
               [0, 1, 0, -delta.y],
               [0, 0, 1, -delta.z],
               [0, 0, 0,        1]]
    return new Transform(new Matrix4x4(matrix), new Matrix4x4(inverse))

  # ### *Transform.Scale:*
  # > **`Transform.Scale`** creates a **`Transform`** that performs a scale in each of the *X*, *Y* and *Z* directions as given.
  @Scale: (x, y, z) ->
    matrix = [[x, 0, 0, 0], 
              [0, y, 0, 0],
              [0, 0, z, 0],
              [0, 0, 0, 1]]
    inverse = [[1/x, 0,   0,   0], 
               [0, 1/y,   0,   0],
               [0,   0, 1/z,   0],
               [0,   0,   0,   1]]
    return new Transform(new Matrix4x4(matrix), new Matrix4x4(inverse))

  # ### *Transform.RotateX:*
  # > **`Transform.RotateX`** creates a **`Transform`** that performs a rotation around the *X* axis by `degrees`.
  @RotateX: (degree) ->
    s = Math.sin MathFunctions.Radians(degree)
    c = Math.cos MathFunctions.Radians(degree)
    matrix = [[1, 0,  0, 0], 
              [0, c, -s, 0],
              [0, s,  c, 0],
              [0, 0,  0, 1]]
    matrix = new Matrix4x4(matrix)
    return new Transform(matrix, Matrix4x4.Transpose(matrix))

  # ### *Transform.RotateY:*
  # > **`Transform.RotateY`** creates a **`Transform`** that performs a rotation around the *Y* axis by `degrees`.
  @RotateY: (degree) ->
    s = Math.sin MathFunctions.Radians(degree) 
    c = Math.cos MathFunctions.Radians(degree)
    matrix = [[c,  0, s, 0],
              [0,  1, 0, 0],
              [-s, 0, c, 0],
              [0,  0, 0, 1]]
    matrix = new Matrix4x4(matrix)
    return new Transform(matrix, Matrix4x4.Transpose(matrix))

  # ### *Transform.RotateZ:*
  # > **`Transform.RotateZ`** creates a **`Transform`** that performs a rotation around the *Z* axis by `degrees`.
  @RotateZ: (degree) ->
    s = Math.sin MathFunctions.Radians(degree) 
    c = Math.cos MathFunctions.Radians(degree)
    matrix = [[c, -s, 0, 0],
              [s,  c, 0, 0],
              [0,  0, 1, 0],
              [0,  0, 0, 1]]
    matrix = new Matrix4x4(matrix)
    return new Transform(matrix, Matrix4x4.Transpose(matrix))

  # ### *Transform.Rotate:*
  # > **`Transform.Rotate`** creates a **`Transform`** that performs a rotation around an arbitrary axis described by a **`Vector`**.
  @Rotate: (degree, axis) ->
    n = Vector.Normalise axis
    s = Math.sin MathFunctions.Radians(degree)
    c = Math.cos MathFunctions.Radians(degree)
    matrix = [[],[],[],[]]
    matrix[0][0] = n.x * n.x + (1 - n.x * n.x) * c
    matrix[0][1] = n.x * n.y * (1 - c) - n.z * s
    matrix[0][2] = n.x * n.z * (1 - c) + n.y * s
    matrix[0][3] = 0
    
    matrix[1][0] = n.y * n.x * (1 - c) + n.z * s
    matrix[1][1] = n.y * n.y + (1 - n.y * n.y) * c
    matrix[1][2] = n.y * n.z * (1 - c) - n.x * s
    matrix[1][3] = 0
    
    matrix[2][0] = n.z * n.x * (1 - c) - n.y * s
    matrix[2][1] = n.z * n.y * (1 - c) + n.x * s
    matrix[2][2] = n.z * n.z + (1 - n.z * n.z) * c
    matrix[2][3] = 0
    
    matrix[3][0] = 0
    matrix[3][1] = 0
    matrix[3][2] = 0
    matrix[3][3] = 1
    matrix = new Matrix4x4(matrix)
    return new Transform(matrix, Matrix4x4.Transpose(matrix))
    
  # ### *Transform.LookAt:*
  # > **`Transform.LookAt`** creates a **`Transform`** that causes an object to "look at" another [**`Point`**](geometry.html#point). Particularly useful for placing a [**Camera**](camera.html#camera) in the scene.
  @LookAt: (position, look, up) ->
    forward = Vector.Normalise Point.SubtractPointFromPoint(look, position)
    left = Vector.Normalise Vector.Cross(Vector.Normalise(up), forward)
    newUp = Vector.Cross(forward, left)
    matrix = [[],[],[],[]]
    matrix[0][0] = left.x
    matrix[0][1] = newUp.x
    matrix[0][2] = forward.x
    matrix[0][3] = position.x
    
    matrix[1][0] = left.y
    matrix[1][1] = newUp.y
    matrix[1][2] = forward.y
    matrix[1][3] = position.y
    
    matrix[2][0] = left.z
    matrix[2][1] = newUp.z
    matrix[2][2] = forward.z
    matrix[2][3] = position.z
    
    matrix[3][0] = 0
    matrix[3][1] = 0
    matrix[3][2] = 0
    matrix[3][3] = 1
    matrix = new Matrix4x4(matrix)
    return new Transform(matrix, Matrix4x4.Transpose matrix)

  # ___
  # ### **Apply transformations:**
  
  # These functions are static implementations which apply a given **`Transform`** to a given object such as a [**`Point`**](geometry.html#point) or [**`Vector`**](geometry.html#point).
  
  # ### *Transform.TransformPoint:*
  # > **`Transform.TransformPoint`** transforms a **`Point`** by a given **`Transform`**.
  @TransformPoint: (t, p) ->
    m = t.matrix.m
    x = p.x
    y = p.y
    z = p.z
    xp = m[0][0] * x + m[0][1] * y + m[0][2] * z + m[0][3]   
    yp = m[1][0] * x + m[1][1] * y + m[1][2] * z + m[1][3]
    zp = m[2][0] * x + m[2][1] * y + m[2][2] * z + m[2][3]
    wp = m[3][0] * x + m[3][1] * y + m[3][2] * z + m[3][3]
    if wp is 1 then return new Point(xp, yp, zp)
    return Point.Divide new Point(xp, yp, zp), wp
    
  # ### *Transform.TransformVector:*
  # > **`Transform.TransformVector`* transforms a **`Vector`** by a given **`Transform`**.
  @TransformVector: (t, v) ->
    m = t.matrix.m
    x = v.x
    y = v.y
    z = v.z
    return new Vector(m[0][0] * x + m[0][1] * y + m[0][2] * z,
                      m[1][0] * x + m[1][1] * y + m[1][2] * z,
                      m[2][0] * x + m[2][1] * y + m[2][2] * z)

  # ### *Transform.TransformNormal:*
  # > **`Transform.TransformNormal`** transforms a [**`Normal`**](geometry.html#normal) by a given **`Transform`**.         
  @TransformNormal: (t, n) ->
    i = t.inverse.m
    x = n.x
    y = n.y
    z = n.z
    return new Normal(i[0][0] * x + i[1][0] * y + i[2][0] * z,
                      i[0][1] * x + i[1][1] * y + i[2][1] * z,
                      i[0][2] * x + i[1][2] * y + i[2][2] * z)

  # ### *Transform.TransformRay:*
  # > **`Transform.TransformRay`** transforms a [**`Ray`**](geometry.html#ray) by a given **`Transform`**.
  @TransformRay: (t, r) ->
    rRet = new Ray()
    for key, value of r
      rRet[key] = value
    rRet.origin = Transform.TransformPoint t, rRet.origin
    rRet.direction = Transform.TransformVector t, rRet.direction
    return rRet
  
  # ### *Transform.TransformRayDifferential:*
  # > **`Transform.TransformRayDifferential`** transforms a *[*`RayDifferential`**](geometry.html#raydiff) by a given **`Transform`**.
  @TransformRayDifferential: (t, rd) ->
    rdRet = new RayDifferential()
    for own key, value of rd
      rdRet[key] = value
    rdRet.origin = Tranform.TransformPoint t, rdRet.origin
    rdRet.direction = Tranform.TransformVector t, rdRet.direction
    rdRet.rayXOrigin = Tranform.TransformPoint t, rdRet.rayXOrigin
    rdRet.rayXDirection = Tranform.TransformVector t, rdRet.rayXDirection
    rdRet.rayYOrigin = Tranform.TransformPoint t, rdRet.rayYOrigin
    rdRet.rayYDirection = Tranform.TransformVector t, rdRet.rayYDirection
    return rdRet

  # ### *Transform.TransformBoundingBox:*
  # > **`Transform.TransformBoundingBox`** transforms a [**`BoundingBox`**](geometry.html#bbox) by a given **`Transform`**.
  @TransformBoundingBox: (t, b) ->
    bRet = new BoundingBox(Transform.TransformPoint(t, new Point(b.pMin.x, b.pMin.y, b.pMin.z)))
    Union = BoundingBox.UnionBBoxAndPoint
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMax.x, b.pMin.y, b.pMin.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMin.x, b.pMax.y, b.pMin.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMin.x, b.pMin.y, b.pMax.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMin.x, b.pMax.y, b.pMax.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMax.x, b.pMax.y, b.pMin.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMax.x, b.pMin.y, b.pMax.z)))
    bRet = Union(bRet, Transform.TransformPoint(t, new Point(b.pMax.x, b.pMax.y, b.pMax.z)))
    return bRet  

  # ___
  # ### **Camera transformations:**
  
  # These functions are static implementations which generate projective transformations for implementations of the [**`Camera`**](camera.html#camera) class.
    
  # ### *Transform.Orthographic:*
  # > **`Transform.Orthographic`** creates an orthographic projection **`Transform`** for [**`OrthographicCamera`**](camera.html#orthographic)s.
  @Orthographic: (znear, zfar) ->
    return Transform.Multiply(Transform.Scale(1, 1, 1 / (zfar - znear)), Transform.Translate(new Vector(0,0,-znear)))

  # ### *Transform.Perspective:*
  # > **`Transform.Perspective`** creates an perspective projection **Transform** for [**`PerspectiveCamera`**](camera.html#perspective)s.
  @Perspective: (fov, near, far) ->
    persp = new Matrix4x4([[1,0,0,0],
                           [0,1,0,0],
                           [0,0,far / (far - near), -far * near / (far - near)],
                           [0,0,1,0]])
    invTan = 1 / Math.tan(MathFunctions.Radians(fov)) / 2
    return Transform.Multiply(Transform.Scale(invTan, invTan, 1), new Transform(persp))

# ___
# ## Exports:

# The [**`Transform`**](#transform) class is added to the global `root` object.
root = exports ? this
root.Transform = Transform