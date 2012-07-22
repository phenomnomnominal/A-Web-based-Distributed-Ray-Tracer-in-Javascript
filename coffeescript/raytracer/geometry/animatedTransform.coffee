# *animatedTransform.coffee* contains classes for animating transforms,
# specifically the **[`Quaternion`][1]** class and the
# **[`AnimatedTransform`][2]**.
# ___
#
# <!--- URLs -->
# [1]: #quat "Quaternion"
# [2]: #animT "AnimatedTransform"

# ## Requires:
# Classes in *animatedTransform.coffee* require access to the following
# libraries:

# > * [**`_`**](http://underscorejs.org/) - *underscore.js utility library*
_ = this._ ? if require? then require 'underscore'

# ## <section id='quat'>Quaternion:</section>
# ___
#
# In two dimensions *(x,y)*, imaginary numbers are numbers in the form:
#
# > *x + yi*, with *i<sup>2</sup> = &minus;1*.
#
# A **`Quaternion`** is a generalisation of imaginary numbers into four
# dimensions
#
# > *q = (x, y, z, w) = w + xi + yj + zk*
#
# where
#
# > *i<sup>2</sup> = j<sup>2</sup> = k<sup>2</sup> = i × j × k = &minus;1.*
#
# **`Quaternion`**s provide an elegant representation of a rotation, which
# leads to elegant - and correct - methods for interpolating between rotations,
# which are used for animations.
class Quaternion
  # ### *constructor:*
  # > The **`Quaternion`** constructor requires two parameters:
  #
  # > * A **[`Vector`][1]** to represent the *X*, *Y* and *Z* components of the
  # **`Quaternion`**: `v` - must be a **`Vector`**
  #
  # > * A number to represent the *W* component: `w`
  #
  # > If these are supplied by the user and are of the incorrect type, the
  # constructor will throw an **`Error`**.
  #
  # > If no arguments are provided, a unit **`Quaternion`** is initialised:
  # >> *q = (0, 0, 0, 1)*
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector "Vector"
  constructor: (@v = new Vector(), @w = 1) ->

    unless @v.constructor.name is 'Vector'
      throw Error 'Quaternion Constructor Error: v must be a Vector.'
    unless _.isNumber @w
      throw Error 'Quaternion Constructor Error: w must be a Number.'

  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`Quaternion`** class
  # - changing the function of one **`Quaternion`** changes the function on all
  # other **`Quaternion`**s as well. These functions act on a **`Quaternion`**
  # in place - the original object is modified.

  # ### **Arithmetic methods:**
  # > Arithmetic with **`Quaternion`** instances is performed component-wise,
  # for example:
  #
  # > *q + q' = (w + w'), (x + x') × i, (y + y') × j, (z + z') × k*
  #
  # > *q × 3 = (w × 3), (x × 3) × i, (y × 3) × j, (z × 3) × k*

  # > ### *add:*
  # >> **`add`** uses **[`Vector.add`][1]** to add the *X*, *Y* and *Z*
  # **`Vector`** components and simple addition for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-add "Vector.add"
  
  add: (q) ->
    @v.add q.v
    @w += q.w
    return this

  # > ### *subtract:*
  # >> **`subtract`** uses **[`Vector.subtract`][1]** to subtract the *X*, *Y*
  # and *Z* **`Vector`** components and simple subtraction for the *W*
  # component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-subtract "Vector.subtract"
  
  subtract: (q) ->
    @v.subtract q.v
    @w -= q.w
    return this

  # > ### *multiply:*
  # >> **`multiply`** uses **[`Vector.multiply`][1]** to multiply the *X*, *Y*
  # and *Z* **`Vector`** components and simple multiplication for the *W*
  # component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-muliply "Vector.multiply"

  multiply: (f) ->
    @v.multiply f
    @w *= f
    return this

  # > ### *divide:*
  # >> **`divide`** uses **[`Vector.divide`][1]** to divide the *X*, *Y* and
  # *Z* **`Vector`** components and simple division for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-divide "Vector.divide"
  
  divide: (f) ->
    @v.divide f
    @w /= f
    return this

  # ___
  # ### Static Functions:

  # These functions belong to the **`Quaternion`** class - any object arguments
  # are not modified and a new object is always returned.

  # ### *Quaternion.ToTransform:*
  # > **`Quaternion.ToTransform`** provides the ability to generate a
  # **[`Transform`][1]** that represents the same rotation as an existing
  # **`Quaternion`**.
  #
  # > Transforming a **[`Point`][2]** by a **`Quaternion`** is given by:
  #
  # >> *p' = q × p × q<sup>&minus;1</sup>*.
  #
  # > By expanding out and simplifying the multiplication of
  # >> *q × p × q<sup>&minus;1</sup>*
  #
  # > we can find the matrix that represents the same transformation and
  # generate a new **`Transform`**. Note that the 4th Row and Column are
  # unspecified, so the **[`Matrix4x4`][3]** constructor will fill the
  # `Transform.matrix` and `Transform.inverse` properties with values from the
  # identity matrix.
  #
  # <!--- URLs -->
  # [1]: transform.html#transform "Transform"
  # [2]: geometry.html#point "Point"
  # [3]: matrix.html#matrix "Matrix4x4"
  @ToTransform: (q) ->
    xx = q.v.x * q.v.x; yy = q.v.y * q.v.y; zz = q.v.z * q.v.z
    xy = q.v.x * q.v.y; xz = q.v.x * q.v.z; yz = q.v.y * q.v.z
    wx = q.v.x * q.w; wy = q.v.y * q.w; wz = q.v.z * q.w

    m = [[],[],[],[]]
    m[0][0] = 1 - 2 * (yy + zz)
    m[0][1] = 2 * (xy + wz)
    m[0][2] = 2 * (xz - wy)
    m[1][0] = 2 * (xy - wz)
    m[1][1] = 1 - 2 * (xx + zz)
    m[1][2] = 2 * (yz + wx)
    m[2][0] = 2 * (xz + wy)
    m[2][1] = 2 * (yz - wx)
    m[2][2] = 1 - 2 * (xx + yy)
    
    matrix = new Matrix4x4(m)
    transpose = Matrix4x4.Transpose matrix
    return new Transform(transpose, matrix)

  # ### *Quaternion.FromTransform:*
  # > **`Quaternion.FromTransform`** provides the ability to generate a
  # **`Quaternion`** object from an existing **[`Transform`][1]**
  #
  # > This implementation is from Shoemake's 1991 paper **[Quaternions][]**.
  #
  # <!--- URLs -->
  # [1]: transform.html#transform "Transform"
  # [quaternions]: http://www.cs.ucr.edu/~vbz/resources/quatut.pdf
  @FromTransform: (t) ->
    m = t.matrix
    trace = m.m[0][0] + m.m[1][1] + m.m[2][2]
    if trace > 0
      s = Math.sqrt(trace + 1)
      w = s * 0.5
      s = 0.5 / s
      x = (m.m[2][1] - m.m[1][2]) * s
      y = (m.m[0][2] - m.m[2][0]) * s
      z = (m.m[1][0] - m.m[0][1]) * s
      return new Quaternion(new Vector(x, y, z), w)
    else
      next = [1,2,0]
      q = []
      i = 0
      if m.m[1][1] > m.m[0][0] then i = 1
      if m.m[2][2] > m.m[i][i] then i = 2
      j = next[i]
      k = next[j]
      s = Math.sqrt((m.m[i][i] - (m.m[j][j] + m.m[k][k])) + 1.0)
      q[i] = s * 0.5
      if s isnt 0 then s = 0.5 / s
      w = (m.m[k][j] - m.m[j][k]) * s
      q[j] = (m.m[j][i] + m.m[i][j]) * s
      q[k] = (m.m[k][i] + m.m[i][k]) * s
      return new Quaternion(new Vector(q[0], q[1], q[2]), w)
  
  # ### **Arithmetic methods:**
  # Static implementations of basic arithmetic functions are also available.
  # These functions operate on existing **`Quaternion`** instances and use
  # their static counterparts from the **[`Vector`][1]** class.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector "Vector"
        
  # > ### *Quaternion.Add:*
  # >> **`Quaternion.Add`** uses **[`Vector.Add`][1]** to add the *X*, *Y* and
  # *Z* **`Vector`**  components from each **`Quaternion`** and simple addition
  # for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-Add "Vector.Add"
  
  @Add: (q1, q2) ->
    v = Vector.Add q1.v, q2.v
    w = q1.w + q2.w
    return new Quaternion(v, w)

  # > ### *Quaternion.Subtract:*
  # >> **`Quaternion.Subtract`** uses **[`Vector.Subtract`][1]** to subtract
  # the *X*, *Y* and *Z* **`Vector`** components from each **`Quaternion`** and
  # simple subtraction for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-Subtract "Vector.Subtract"
  
  @Subtract: (q1, q2) ->
    v = Vector.Subtract q1.v, q2.v
    w = q1.w - q2.w
    return new Quaternion(v, w)

  # > ### *Quaternion.Multiply:*
  # >> **`Quaternion.Multiply`** uses **[`Vector.Multiply`][1]** to mutliply
  # the *X*, *Y* and *Z* **`Vector`** components from each **`Quaternion`** and
  # simple multiplication for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-Multiply "Vector.Multiply"

  @Multiply: (q, f) ->
    v = Vector.Multiply q.v, f
    w = q.w * f
    return new Quaternion(v, w)
    
  # > ### *Quaternion.Divide:*
  # >> **`Quaternion.Divide`** uses **[`Vector.Divide`][1]** to divide the *X*,
  # *Y* and *Z* **`Vector`** components from each **`Quaternion`** and simple
  # division for the *W* component.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-Divide "Vector.Divide"
  
  @Divide: (q, f) ->
    v = Vector.Divide q.v, f
    w = q.w / f
    return new Quaternion(v, w)
    
  # > ### *Quaternion.Dot:*
  # >> **`Quaternion.Dot`** uses **[`Vector.Dot`][1]** to perform the
  # **[Dot Product][]** of the *X*, *Y* and *Z* **`Vector`** components from
  # each **`Quaternion`** and adds the product of the *W* components.
  #
  # <!--- URLs -->
  # [1]: geometry.html#vector-Dot "Vector.Dot"
  # [dot product]: http://en.wikipedia.org/wiki/Dot_product "Dot Product"
    
  @Dot: (q1, q2) ->
    return (Vector.Dot q1.v, q2.v) + q1.w * q2.w
  
  # ### *Quaternion.Normalise:*
  # > A **`Quaternion`** can be **[Normalised][]** by dividing itself by its
  # length, which is computed as the square-root of its **[Dot Product][]**
  # with itself.
  #
  # <!--- URLs -->
  # [normalised]: http://en.wikipedia.org/wiki/Unit_vector "Normalise"
  # [dot product]: http://en.wikipedia.org/wiki/Dot_product "Dot Product"
  @Normalise: (q) ->
    return Quaternion.Divide q, Math.sqrt(Quaternion.Dot(q, q))
  
  # ### <section id='slerp'>*Quaternion.SphericalLinearInterpolation:*<section>
  # > **`SphericalLinearInterpolation`** (sometime known as *slerp*) is used to
  # interpolate between **`Quaternion`** instances, and provides more robust
  # and correct results than simple *Linear Interpolation* for two reasons.
  #
  # > 1. The path to get between two rotations is the shortest possible path in
  # rotation space
  # > 2. The speed of interpolation is constant across the interpolation range
  #
  # > If two **`Quaternion`** instances are nearly parallel, regular *Linear
  # Interpolation* is sufficient.
  #
  # > Otherwise, a **`Quaternion`** that is orthogonal to `q1` and `q2` is
  # found with
  # >> *q<sub>orth</sub> = q<sub>2</sub> &minus; (q<sub>1</sub> .
  # q<sub>2</sub>) × q<sub>1</sub>*,
  #
  # > and the interpolation is computed with
  # >> *q<sub>int</sub> = q<sub>1</sub> × cos(&theta; × t) + q<sub>orth</sub>
  # × sin(&theta; × t)*
  @SphericalLinearInterpolation: (t, q1, q2) ->
    cosTheta = Quaternion.Dot q1, q2
    if cosTheta > 0.9995
      q1Part = Quaternion.Multiply(q1, (1 - t))
      q2Part = Quaternion.Multiply(q2, t)
      return Quaternion.Normalise(Quaternion.Add(q1Part, q2Part))
             
    else
      theta = Math.acos MathFunction.Clamp(cosTheta, -1, 1)
      thetap = theta * t
      q1Cos = Quaternion.Multiply(q1, cosTheta)
      qperp = Quaternion.Normalise(Quaternion.Subtract(q2, q1Cos))
      return Quaternion.Add(Quaternion.Multiply(q1, Math.cos(thetap)),
                            Quaternion.Multiply(qperp, Math.sin(thetap)))

# ___

# ## <section id='animT'>AnimatedTransform:</section>
# ___

# An **`AnimatedTransform`** describes a transformation on an object over time
# from a `startTransform` to an `endTransform`. These can be interpolated
# between to get a **[`Transform`][1]** that describes the transformation at a
# given time.
#
# <!--- URLs -->
# [1]: transform.html#transform "Transform"
class AnimatedTransform
  # ### *constructor:*
  # > The **`AnimatedTransform`** constructor requires four parameters:
  #
  # > * The starting transformation: `startTransform` - must be a
  # **`Transform`**
  #
  # > * A time value assosciated with the `startTransform`: `startTime`
  #
  # > * The end transformation: `endTransform` - must be a **`Transform`**
  #
  # > * A time value assosciated with the `endTransform`: `endTime`
  #
  # > If these are not supplied or are of the incorrect type, the constructor
  # will throw an **`Error`**.
  #
  # > The boolean `actuallyAnimated` flag is set when the `startTransform` and
  # `endTransform` are different.
  #
  # > The `startTransform` and `endTransform` are each decomposed into:
  #
  # > * **`Transform`** translation
  #
  # > * **[`Quaternion`][1]** rotation
  #
  # > * **`Transform`** scale
  #
  # > which are associated as `start`:`end` pairs.
  #
  # <!--- URLs -->
  # [1]: #quat "Quaternion"
  constructor: (@startTransform, @startTime, @endTransform, @endTime) ->
    
    unless @startTransform?
      throw Error 'AnimatedTransform Constructor Error: "startTransform must be defined."'
    unless @startTransform.constructor.name is 'Transform'
      throw Error 'AnimatedTransform Constructor Error: "startTransform must be a Transform."'
    unless @startTime?
      throw Error 'AnimatedTransform Constructor Error: "startTime must be defined."'
    unless _.isNumber @startTime
      throw Error 'AnimatedTransform Constructor Error: "startTime must be a Number."'
    unless @endTransform?
      throw Error 'AnimatedTransform Constructor Error: "endTransform must be defined."'
    unless @endTransform.constructor.name is 'Transform'
      throw Error 'AnimatedTransform Constructor Error: "endTransform must be a Transform."'
    unless @endTime?
      throw Error 'AnimatedTransform Constructor Error: "endTime must be defined."'
    unless _.isNumber @endTime
      throw Error 'AnimatedTransform Constructor Error: "endTime must be a Number."'

    @actuallyAnimated = !Transform.Equals @startTransform, @endTransform
    decomposeStart = AnimatedTransform.Decompose @startTransform.matrix
    decomposeEnd = AnimatedTransform.Decompose @endTransform.matrix
    @translation = start: decomposeStart.t, end: decomposeEnd.t
    @rotation = start: decomposeStart.r, end: decomposeEnd.r
    @scale = start: decomposeStart.s, end: decomposeEnd.s

  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the
  # **`AnimatedTransform`** class - changing the function of one
  # **`AnimatedTransform`** changes the function on all other
  # **`AnimatedTransform`**s as well. These functions act on a
  # **`AnimatedTransform`** instance in place - the original object is
  # modified.

  # ### *hasScale:*
  # > **`hasScale`** checks whether either the `startTransform` or the
  # `endTransform` properties have any scaling factors in them.
  hasScale: ->
    return @startTransform.hasScale() || @endTransform.hasScale()

  # ___
  # ### Static Functions:
  
  # These functions belong to the **`AnimatedTransform`** class - any object
  # arguments are not modified and a new object is always returned.
  
  # ### *AnimatedTransform.Decompose:*
  # > **`Decompose`** takes an overall transformation and splits it into
  # its translation, rotation and scaling components. This allows the rotation
  # to be turned into an equivalent **[`Quaternion`][1]** to allow the
  # **`AnimatedTransform`** to be interpolated correctly.
  #
  # > The translation component can be read directly from the matrix.
  #
  # > Then, a copy of the matrix is made and the translation values are
  # removed.
  #
  # > Polar decomposition is then used to extract the rotation component (R)
  # from M, by successively averaging M to its inverse transpose:
  # >> *M<sub>(i+1)</sub> = (M<sub>i</sub> + (M<sub>i</sub><sup>T</sup>)
  #<sup>&minus;1</sup>) / 2*
  #
  # >Lastly, since we know M and R, and we know that
  # >> *M = R * S,*
  #
  # > we can find S, which represents the scale component.
  #
  # <!--- URLs -->
  # [1]: #quat "Quaternion"
  @Decompose: (m) ->
    translation = new Vector(m.m[0][3], m.m[1][3], m.m[2][3])
    M = new Matrix4x4()
    for copyRow in [0...4]
      for copyColumn in [0...4]
        M.m[copyRow][copyColumn] = m.m[copyRow][copyColumn]
        if copyRow is 3 or copyColumn is 3
          M.m[copyRow][copyColumn] = 0
        if copyRow is 3 and copyColumn is 3
          M.m[copyRow][copyColumn] = 1
    norm = null
    count = 0
    R = new Matrix4x4()
    for copyRow in [0...4]
      for copyColumn in [0...4]
        R.m[copyRow][copyColumn] = M.m[copyRow][copyColumn]
    loop
      Rnext = new Matrix4x4()
      RInvTrans = Matrix4x4.Inverse Matrix4x4.Transpose(R)
      for i in [0...4]
        for j in [0...4]
          Rnext.m[i][j] = 0.5 * (R.m[i][j] + RInvTrans.m[i][j])
      R = Rnext
      norm = 0
      for i in [0...4]
        n  = Math.abs(R.m[i][0] - Rnext.m[i][0]) +
             Math.abs(R.m[i][1] - Rnext.m[i][1]) +
             Math.abs(R.m[i][2] - Rnext.m[i][2])
        norm = Math.max(norm, n)
      break unless count++ < 100 and norm > 0.0001
    rotation = Quaternion.FromTransform new Transform(R)
    scale = Matrix4x4.Multiply Matrix4x4.Inverse(R), M
    return t: translation, r: rotation, s: scale
  
  # ### *AnimatedTransform.Interpolate:*
  # > **`Interpolate`** computes the interpolated value of an
  # **`AnimatedTransform`** at a given `time`.
  #
  # > If the `actuallyAnimated` flag isn't set, or the given `time` is less than
  # the `startTime`, the `startTransform` is returned.
  #
  # > Similarly, if the given `time` is greated than the `endTime`, the
  # `endTransform` is returned.
  #
  # > Otherwise, the **[`LinearInterpolation`][1]** of the
  # translation components is computed, as well as the
  # **[`SphericalLinearInterpolation`][2]** of the rotation components, and the
  # **`LinearInterpolation`** of the scale components.
  #
  # > The product of the three component interpolations is the final resulting
  # interpolation.
  #
  # <!--- URLs -->
  # [1]: math.html#lerp "LinearInterpolation"
  # [2]: #slerp "SphericalLinearInterpolation"
  @Interpolate: (at, time) ->
    if not at.actuallyAnimated or time <= at.startTime
      return at.startTransform
      
    if time >= at.endTime
      return at.endTransform
      
    dt = (time - at.startTime) / (at.endTime - at.startTime)
    tStart = Vector.Multiply(at.translation.start, (1 - dt))
    tEnd = Vector.Multiply(at.translation.end, dt)
    translation = Vector.Add(tStart, tEnd)
    rStart = at.rotation.start
    rEnd = at.rotation.end
    rotate = Quaternion.SphericalLinearInterpolation dt, rStart, rEnd
    scale = new Matrix4x4()
    for i in [0...3]
      for j in [0...3]
        sStart = at.scale.start.m[i][j]
        sEnd = at.scale.end.m[i][j]
        scale.m[i][j] = MathFunctions.LinearInterpolation dt, sStart, sEnd
    translateT = Transform.Translate translation
    rotateT = Quaternion.ToTrasform rotate
    scaleT = new Transform(scale)
    return Transform.Multiply [translate, rotate, scale]...

  # ### *AnimatedTransform.TransformRay:*
  # > **`TransformRay`** applies the **`AnimatedTransform`** to a **[`Ray`][1]**
  # instance using the `time` of the **`Ray`**.
  #
  # > If the `actuallyAnimated` flag isn't set, or the `time` of the **`Ray`**
  # is less than the `startTime`, of the **`AnimatedTransform`**, the **`Ray`**
  # is transformed by the `startTransform` of the **`AnimatedTransform`**.
  #
  # > Similarly, if the `time` of the **`Ray`** is greated than the `endTime`
  # of the **`AnimatedTransform`**, the **`Ray`** is transformed by the
  # `endTransform` of the **`AnimatedTransform`**.
  #
  # > Otherwise, the **`AnimatedTransform`** is interpolated for the correct
  # time and the **`Ray`** is transformed by the resulting transformation.
  #
  # <!--- URLs -->
  # [1]: geometry.html#ray "Ray"
  @TransformRay: (at, ray) ->
    if not at.actuallyAnimated or ray.time <= at.startTime
      return Transform.TransformRay at.startTransform, ray
    else if ray.time < at.endTime
      return Transform.TransformRay at.endTansform, ray
    t = AnimatedTransform.Interpolate at, ray.time
    return Transform.TransformRay t, ray

  # ### *AnimatedTransform.TransformRayDiff:*
  # > **`TransformRayDiff`** applies the **`AnimatedTransform`** to a
  # **[`RayDifferential`][1]** instance using the `time` of the
  # **`RayDifferential`**.
  #
  # > If the `actuallyAnimated` flag isn't set, or the `time` of the
  # **`RayDifferential`** is less than the `startTime` of the
  # **`AnimatedTransform`**, the **`RayDifferential`** is transformed by the
  # `startTransform` of the **`AnimatedTransform`**.
  #
  # > Similarly, if the `time` of the **`RayDifferential`** is greated than the
  # `endTime` of the **`AnimatedTransform`**, the **`RayDifferential`** is
  # transformed by the `endTransform` of the **`AnimatedTransform`**.
  #
  # > Otherwise, the **`AnimatedTransform`** is interpolated for the correct
  # time and the **`RayDifferential`** is transformed by the resulting
  # transformation.
  #
  # <!--- URLs -->
  # [1]: geometry.html#raydiff "RayDifferential"
  @TransformRayDiff: (at, rayDiff) ->
    if not at.actuallyAnimated or rayDiff.time <= at.startTime
      return Transform.TransformRay at.startTransform, rayDiff
    else if rayDiff.time < at.endTime
      return Transform.TransformRay at.endTansform, rayDiff
    t = AnimatedTransform.Interpolate at, rayDiff.time
    return Transform.TransformRay t, rayDiff
  
  # ### *AnimatedTransform.TransformPoint:*
  # > **`TransformPoint`** applies the **`AnimatedTransform`** to a
  # **[`Point`][1]** instance for a given `time`.
  #
  # > If the `actuallyAnimated` flag isn't set, or the `time` is less than the
  # `startTime` of the **`AnimatedTransform`**, the **`Point`** is transformed
  # by the `startTransform` of the **`AnimatedTransform`**.
  #
  # > Similarly, if the `time` is greated than the `endTime` of the
  # **`AnimatedTransform`**, the **`Point`** is transformed by the
  # `endTransform` of the **`AnimatedTransform`**.
  #
  # > Otherwise, the **`AnimatedTransform`** is interpolated for the correct
  # time, and the **`Point`** is transformed by the resulting transformation.
  #
  # <!--- URLs -->
  # [1]: geometry.html#point "Point"
  @TransformPoint: (at, time, point) ->
    if not at.actuallyAnimated or time <= at.startTime
      return Transform.TransformPoint at.startTransform, point
    else if time >= at.endTime
      return Transform.TransformPoint at.endTransform, point
    t = AnimatedTransform.Interpolate at, time
    return Transform.TransformPoint t, point

  # ### *AnimatedTransform.TransformVector:*
  # > **`TransformVector`** applies the **`AnimatedTransform`** to a
  # **[`Vector`][1]** instance for a given `time`.
  #
  # > If the `actuallyAnimated` flag isn't set, or the `time` is less than the
  # `startTime` of the **`AnimatedTransform`**, the **`Vector`** is transformed
  # by the `startTransform` of the **`AnimatedTransform`**.
  #
  # > Similarly, if the `time` is greated than the `endTime` of the
  # **`AnimatedTransform`**, the **`Vector`** is transformed by the
  # `endTransform` of the **`AnimatedTransform`**.
  #
  # > Otherwise, the **`AnimatedTransform`** is interpolated for the correct
  # time, and the **Vector** is transformed by the resulting transformation.
  #
  # <!-- URLs -->
  # [1]: geometry.html#vector "Vector"
  @TransformVector: (at, time, vector) ->
    if not at.actuallyAnimated or time <= at.startTime
      return Transform.TransformVector at.startTransform, vector
    else if time >= at.endTime
      return Transform.TransformVector at.endTransform, vector
    t = AnimatedTransform.Interpolate at, time
    return Transform.TransformVector t, vector

  # ### *AnimatedTransform.MotionBounds:*
  # > **`MotionBounds`** creates a [**`BoundingBox`**](geometry.html#bbox) that
  # encapsulates the entire volume that an object occupies as it undergoes a
  # transformation.
  #
  # > If the `actuallyAnimated` flag isn't set, then return the result of
  # transforming `b` by the Inverse of `startTransform`.
  #
  # > Otherwise create an overall **`BoundingBox`** by incrementally
  # interpolating the **`AnimatedTransform`** and performing the **[Union][]**
  # operation on the result of applying the interpolated transform to the
  # current **`BoundingBox`**.
  #
  # <!--- URLs -->
  # [union]: http://en.wikipedia.org/wiki/Union_(set_theory\) "Union"
  @MotionBounds: (at, b, useInverse) ->
    if not at.actuallyAnimated
      return Transform.TransformBBox Transform.Inverse(at.startTransform), b
    bRet = new BoundingBox()
    nSteps = 128
    for i in [0...nSteps]
      st = at.startTime
      et = at.endTime
      time = MathFunctions.LinearInterpolation(i / (nsteps - 1), st, et)
      t = AnimatedTransform.Interpolate at, time
      if useInverse then t = Transform.Inverse t
      bRet = BoundingBox.UnionBBoxAndBBox bRet, Transform.TransformBBox(t, b)
    return bRet

# ___
# ## Exports:

# The **[`Quaternion`][1]** and **[`AnimatedTransform`][2]** classes are added
# to the global `root` object.
#
# <!--- URLs -->
# [1]: #quat "Quaternion"
# [2]: #animT "AnimatedTransform"
root = exports ? this
root.Quaternion = Quaternion
root.AnimatedTransform = AnimatedTransform