# *geometry.coffee* contains mathematical representations of geometric constructs, specifically:
# 
# * [**`Vector`**](#vector)
#
# * [**`Point`**](#point)
#
# * [**`Normal`**](#normal)
#
# * [**`Ray`**](#ray)
#
# * [**`RayDifferential`**](#raydiff)
#
# * [**`BoundingBox`**](#bbox)
# ___

# ## <section id="vector">Vector:<section>
# ___
#
# A **`Vector`** represents a direction in 3D space, as an *X* component, *Y* component and *Z* component.
class Vector
  # ___
  # ### Constructor Functions:
  
  # ### *constructor:*
  # > The standard **`Vector`** constructor takes up to three numbers as parameters, representing the *X*, *Y* and *Z* components respectively. Any component that is not set, becomes `0` by default, therefore, if no arguments are provided, a null **`Vector`** is initialised:
  # >>    *v = (0, 0, 0)*
  #
  # > If any of the components is `NaN`, an error is thrown.
  constructor: (@x = 0, @y = 0, @z = 0) ->
    if isNaN @x or isNaN @y or isNaN @z
      throw new Error "Vector contains a NaN"
  
  # ### *Vector.FromNormal:*
  # > The **`Vector`** class provides a static function for initialising a **`Vector`** from an instance of the [**`Normal`**](#normal) class.
  @FromNormal: (n) ->
    return new Vector(n.x, n.y, n.z)

  # ### *Vector.FromPoint:*
  # > The **Vector** class provides a static function for initialising a **`Vector`** from an instance of the [**`Point`**](#point) class.
  @FromPoint: (p) ->
    return new Vector(p.x, p.y, p.z)

  # ### *Vector.FromVector:*
  # > The **`Vector`** class provides a static function for initialising a **`Vector`** from another instance  of the **`Vector`** class.
  @FromVector: (v) ->
    return new Vector(v.x, v.y, v.z)
    
  # ___  
  # ### Prototypical Instance Functions:
  
  # These functions are attached to each instance of the **`Vector`** class - changing the function of one **`Vector`** changes the function on all other **`Vector`**s as well. These functions act on a **`Vector`** instance in place - the original object is modified.
  
  # ### **Arithmetic methods:**
  # Arithmetic with **`Vector`** instances is performed component-wise, for example:
  #
  # > *v + v' = (v.x + v'.x), (v.y + v'.y), (v.z + v'.z)*
  #
  # > *v × 3' = (v.x × 3), (v.y × 3), (v.z × 3)*
  
  # > ### <section id='vector-add'>*add:*</section>
  # >> **`add`** adds each of the *X*, *Y* and *Z* components of another **`Vector`** to the corresponding components of an instance of the **`Vector`** class.
  add: (v) ->
    @x += v.x
    @y += v.y
    @z += v.z
    return @
  
  # > ### <section id='vector-subtract'>*subtract:*</section>
  # >> **`subtract`** subtracts each of the *X*, *Y* and *Z* components of another **`Vector`** from the corresponding components of an instance of the **`Vector`** class.
  subtract: (v) ->
    @x -= v.x
    @y -= v.y
    @z -= v.z
    return @
  
  # > ### <section id='vector-multiply'>*multiply:*</section>
  # >> **`multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Vector`** class by a given scalar.
  multiply: (scale) ->
    @x *= scale
    @y *= scale
    @z *= scale
    return @

  # > ### <section id='vector-divide'>*divide:*</section>
  # >> **`divide`** divides each of the *X*, *Y* and *Z* components of an instance of the **`Vector`** class by a given scalar.
  #
  # >> An error is thrown if the scalar is `0`.
  #
  # >> One division and three multiplications are performed instead of three divisions for efficiency.
  divide: (scale) ->
    if scale is 0
      throw new Error "Scale value is 0"
    inv = 1 / scale
    @x *= inv
    @y *= inv
    @z *= inv
    return @

  # ### *toArray:*
  # > **`toArray`** returns a **`Vector`** instance as an `Array` object of the form `[X, Y, Z]`.
  toArray: ->
    return [@x, @y, @z]

  # ### *equals:*
  # > **`equals`** checks a **`Vector`** for equality with another **`Vector`**. Two **`Vector`** instances are equal if each of their *X*, *Y* and *Z* components are the same.
  equals: (v) ->
    if v.constructor? and v.constructor.name is "Vector" 
      return @x is v.x and @y is v.y and @z is v.z
    return false

  # ___  
  # ### Static Functions:
      
  # These functions belong to the **`Vector`** class - any object arguments are not 
  # modified and a new object is always returned.
  
  # ### **Arithmetic methods:**
  # Static implementations of basic arithmetic functions are also available. These functions
  # operate on existing **`Vector`** instances.
      
  # > ### <section id='vector-Add'>*Vector.Add:*</section>
  # >> **`Vector.Add`** adds each of the *X*, *Y* and *Z* components of another **`Vector`** to the corresponding components of an instance of the **`Vector`** class.
  @Add: (v1, v2) ->
    return new Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)    
 
  # > ### <section id='vector-Subtract'>*Vector.Subtract:*</section>
  # >> **`Vector.Subtract`** subtracts each of the *X*, *Y* and *Z* components of another **`Vector`** from the corresponding components of an instance of the **`Vector`** class.
  @Subtract: (v1, v2) ->
    return new Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
    
  # > ### <section id='vector-Multiply'>*Vector.Multiply:*</section>
  # >> **`Vector.Multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Vector`** class by a given scalar.
  @Multiply: (v, scale) ->
    return new Vector(v.x * scale, v.y * scale, v.z * scale)

  # > ### <section id='vector-Divide'>*Vector.Divide:*</section>
  # >> **`Vector.Divide`** divides each of the *X*, *Y* and *Z* components of an instance of the **`Vector`** class by a given scalar.
  #
  # >> An error is thrown if the scalar is `0`.
  #
  # >> One division and three multiplications are performed instead of three divisions for efficiency.
  @Divide: (v, scale) ->
    if scale is 0
      throw new Error "Scale value is 0"
    inv = 1 / scale
    return new Vector(v.x * inv, v.y * inv, v.z * inv)

  # ### *Vector.Negate:*
  # > **`Vector.Negate`** returns a **`Vector`** that points in the opposite direction to the given **`Vector`**, by negating each of the *X*, *Y* and *Z* components.
  @Negate: (v) ->
    return new Vector(-v.x, -v.y, -v.z)
    
  # ### *Vector.Equals:*
  # > **`Vector.Equals`** checks a **`Vector`** for equality with another **`Vector`**. Two **`Vector`** instances are equal if each of their *X*, *Y* and *Z* components are the same.
  @Equals: (v1, v2) ->
    if v1.constructor? and v1.constructor.name is "Vector" and v2.constructor? and v2.constructor.name is "Vector"
      return v1.x is v2.x and v1.y is v2.y and v1.z is v2.z
    return false
  
  # ### *Vector.Clone:*
  # > **`Vector.Clone`** creates an exact copy of a **`Vector`**. A Class specific function is used for improved efficiency.
  @Clone: (v) ->
    return new Vector(v.x, v.y, v.z)
  
  # ### <section id='vector-Dot'>*Vector.Dot:*</section>
  # > **`Vector.Dot`** computes the [**Dot Product**](http://en.wikipedia.org/wiki/Dot_product) of two **`Vector`** instances - or a **`Vector`** and a **`Normal`**. The **Dot Product** is defined for *a* and *b* as:
  # >>    *(a.x × b.x) + (a.y × b.y) + (a.z × b.z).*
  #
  # > The **Dot Product** has a simple relationship to the angle between two **`Vector`** instances:
  # >>    *(a &sdot; b) = || a || × || b || × cos(&theta;).*
  @Dot: (a, b) ->
    return a.x * b.x + a.y * b.y + a.z * b.z

  # ### *Vector.AbsDot:*
  # > **`Vector.AbsDot`** computes the [**Absolute Value**](http://en.wikipedia.org/wiki/Absolute_value) of the **Dot Product** of two **`Vector`** instances - or a **`Vector`** and a **`Normal`**.
  @AbsDot: (a, b) ->
    return Math.abs Vector.Dot(a, b)

  # ### *Vector.Cross:*
  # > **`Vector.Cross`** computes the [**Cross Product**](http://en.wikipedia.org/wiki/Cross_product) of two **`Vector`** instances - or a **`Vector`** and a **`Normal`**. The **Cross Product** is defined for *a* and *b* as:
  # >>    *|| (a x b) || = || a || × || b || × sin(&theta;).*
  #
  # > The cross product of two **`Vector`** instances is orthogonal to both.
  @Cross: (a, b) ->
    return new Vector((a.y * b.z) - (a.z * b.y), 
                      (a.z * b.x) - (a.x * b.z), 
                      (a.x * b.y) - (a.y * b.x))
  
  # ### *Vector.Normalise:*
  # > **`Vector.Normalise`** normalises a **`Vector`**, returning a **`Vector`** that points in the same direction, but is of unit length.
  @Normalise: (v) ->
    return Vector.Divide v, Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)

  # ### *Vector.CoodinateSystem*:
  # > **`Vector.CoordinateSystem`** takes a single normalised **`Vector`** and generates three **`Vector`**  instances that form a coordinate system local to the original **`Vector`**.
  #
  # > First, a **`Vector`** (*v<sub>2</sub>*) that is perpendicular to the original **`Vector`** (*v<sub>1</sub>*) is created by zeroing one of the components, swapping the remaining two, and negating one of them.
  # 
  # > Then *v<sub>3</sub>* is generated as the **Cross Product** of *v<sub>1</sub>* and *v<sub>2</sub>*, which by definition will be perpendicular to *v<sub>1</sub>* and *v<sub>2</sub>*.
  @CoordinateSystem: (v1) ->
    if Math.abs v1.x > Math.abs v1.y
      invLength = 1 / Math.sqrt(v1.x * v1.x + v1.z * v1.z)
      v2 = new Vector(-v1.z * invLength, 0, v1.x * invLength)
    else
      invLength = 1 / Math.sqrt(v1.y * v1.y + v1.z * v1.z)
      v2 = new Vector(0, v1.z * invLength, -v1.y * invLength)
    v3 = Vector.Cross v1, v2
    return [v1, v2, v3]
    
# ___

# ## <section id="point">Point:</section>
# ___
# A **Point** represents a zero-dimensional point in 3D space, as an *X* component, *Y* component and *Z* component.
class Point
  # ___
  # ### Constructor Functions:
  
  # ### *constructor:*
  # > The standard **`Point`** constructor takes up to three numbers, representing the *X*, *Y* and *Z* components respectively. Any component that is not set, becomes `0` by default, therefore, if no arguments are provided, a null **`Point`** is initialised:
  # >    *p = (0, 0, 0)*
  #
  # > If any of the components is `NaN`, an error is thrown.
  constructor: (@x = 0, @y = 0, @z = 0) ->
    if isNaN @x or isNaN @y or isNaN @z
      throw new Error "Point contains a NaN"
    
  # ### *Point.FromPoint:*
  # > The **`Point`** class provides a static function for initialising a **`Point`** from another instance of the **`Point`** class.
  @FromPoint: (p) ->
    return new Point(p.x, p.y, p.z)
    
  # ___  
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`Point`** class - changing the function of one **`Point`** changes the function on all other **`Point`**s as well. These functions act on a **`Point`** instance in-place - the original object is modified.

  # ### **Arithmetic methods:**
  # Arithmetic with **Point** instances is performed component-wise, for example:
  #
  # >    *p + p' = (p.x + p'.x), (p.y + p'.y), (p.z + p'.z)*
  #
  # >    *p × 3' = (p.x × 3), (p.y × 3), (p.z × 3)*
  #
  # Certain arithmetic operations on **`Point`** instances can take or return a [**`Vector`**](#vector). For instance, adding a **`Vector`** to a **`Point`** returns the **`Point`** offset by the **`Vector`**, or subtracting a **`Point`** from a **`Point`** returns the **`Vector`** between them.
  
  # > ### *addPoint:*
  # >> **`addPoint`** adds each of the *X*, *Y* and *Z* components of another **`Point`** to the corresponding components of an instance of the **`Point`** class.
  addPoint: (p) ->
    @x += p.x
    @y += p.y
    @z += p.z
    return @

  # > ### *addVector:*
  # >> **`addVector`** adds each of the *X*, *Y* and *Z* components of a **`Vector`** to the corresponding components of an instance of the **`Point`** class.
  addVector: (v) ->
    @x += v.x
    @y += v.y
    @z += v.z
    return @

  # > ### *subtractVector:*
  # >> **`subtractVector`** subtracts each of the *X*, *Y* and *Z* components of a **`Vector`** from the corresponding components of an instance of the **`Point`** class.
  subtractVector: (v) ->
    @x -= v.x
    @y -= v.y
    @z -= v.z
    return @
    
  # > ### *multiply:*
  # >> **`multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Point`** class by a given scalar.
  multiply: (scale) ->
    @x *= scale
    @y *= scale
    @z *= scale
    return @
    
  # > ### *divide:*
  # >> **`divide`** divide each of the *X*, *Y* and *Z* components of an instance of the **`Point`** class by a given scalar.
  divide: (scale) ->
    if scale is 0 then throw new Error "Scale value is 0"
    inv = 1 / scale
    return @.multiply inv
    
  # ### *toArray:*
  # > **`toArray`** returns a **`Point`** instance as an `Array` object of the form `[X, Y, Z]`.
  toArray: ->
    return [@x, @y, @z]
  
  # ### *equals:*
  # > **`equals`** checks a **`Point`** for equality with another **`Point`**. Two **`Point`** instances are equal if each of their *X*, *Y* and *Z* components are the same.
  equals: (p) ->
    if p.constructor? and p.constructor.name is "Point"
      return @x is p.x and @y is p.y and @z is p.z
    else false

  # ___  
  # ### Static Functions:

  # These functions belong to the **`Point`** class - any object arguments are not modified and a new object is always returned.

  # ### **Arithmetic methods**
  # Static implementations of basic arithmetic functions are also available. These functions
  # operate on existing **`Point`** instances.

  # > ### *Point.AddPointToPoint:*
  # >> **`Point.AddPointToPoint`** adds each of the *X*, *Y* and *Z* components of a given **`Point`** to the corresponding components of another **`Point`**, and returns a new **`Point`**.
  @AddPointToPoint: (p1, p2) ->
    return new Point(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
  
  # > ### *Point.AddVectorToPoint:*
  # >> **`Point.AddVectorToPoint`** adds each of the *X*, *Y* and *Z* components of a **`Vector`** to the corresponding components of a **`Point`** and returns a new **`Point`**, which is the **`Point`** shifted in 3D space by the **`Vector`**.
  @AddVectorToPoint: (p, v) ->
    return new Point(p.x + v.x, p.y + v.y, p.z + v.z)

  # > ### *Point.SubtractPointFromPoint:*
  # >> **`Point.SubtractPointFromPoint`** subtracts each of the *X*, *Y* and *Z* components of a given **`Point`** from the corresponding components of another **`Point`** and returns a new **`Vector`**, which is the **`Vector`** between the two.
  @SubtractPointFromPoint: (p1, p2) ->
    return new Vector(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z)

  # > ### *Point.SubtractVectorFromPoint:*
  # >> **`Point.SubtractVectorFromPoint`** subtracts each of the *X*, *Y* and *Z* components of a given **`Vector`** from the corresponding components of a **`Point`** and returns a new **`Point`**, which is the given **`Point`** shifted in 3D space by the negated version of the given **`Vector`**.
  @SubtractVectorFromPoint: (p, v) ->
    return new Point(p.x - v.x, p.y - v.y, p.z - v.z)
  
  # > ### *Point.Multiply:*
  # >> **`Point.Multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Point`** class by a given scalar.
  @Multiply: (p, scale) ->
    return new Point(p.x * scale, p.y * scale, p.z * scale)

  # > ### *Point.Divide:*
  # >> **`Point.Divide`** divide each of the *X*, *Y* and *Z* components of an instance of the **`Point`** class by a given scalar.
  @Divide: (p, scale) ->
    if scale is 0
      throw new Error "Scale value is 0"
    inv = 1 / scale
    return Point.Multiply p, inv

  # ### *Point.Equals:*
  # > **`Point.Equals`** checks a **`Point`** for equality with another **`Point`**. Two **`Point`** instances are equal if each of their *X*, *Y* and *Z* components are the same.
  @Equals: (p1, p2) ->
    if p1.constructor? and p1.constructor.name is "Point" and p2.constructor? and p2.constructor.name is "Point"
      return p1.x is p2.x and p1.y is p2.y and p1.z is p2.z
    return false
    
  # ### *Point.Clone:*
  # > **`Point.Clone`** creates an exact copy of a **`Point`**. A Class specific function is used for improved efficiency.
  @Clone: (p) ->
    return new Point(p.x, p.y, p.z)
    
  # ### *Point.Distance:*
  # > **`Point.Distance`** finds the distance between two **`Point`**s by subtracting them and finding the length of the resulting **`Vector`**.
  @Distance: (p1, p2) ->
    v = Point.SubtractPointFromPoint p1, p2
    return Math.sqrt(Math.pow(v.x, 2) + Math.pow(v.y, 2) + Math.pow(v.z, 2))
  
  # ### *Point.DistanceSquared:*
  # > **`Point.DistanceSquared`** finds the square of the distance between **Point**s by subtracting them, and finding the squared length of the resulting **`Vector`**.
  @DistanceSquared: (p1, p2) ->
    v = Point.SubtractPointFromPoint(p1, p2)
    return Math.pow(v.x, 2) + Math.pow(v.y, 2) + Math.pow(v.z, 2)
    
# ___

# ## <section id='normal'>Normal:</section>
# ___
# A **`Normal`** is a [**`Vector`**](#vector) that is perpendicular to a surface at a particular position.
# Although they are similar to **`Vector`**s, they behave differently in some situations, particularly
# when applying transformations.
class Normal
  # ___
  # ### Constructor Functions:
  
  # ### *constructor:*
  # > The standard **`Normal`** constructor takes up to three numbers as parameters, representing the *X*, *Y* and *Z* components respectively. Any component that is not set, becomes `0` by default, therefore, if no arguments are provided, a null **`Normal`** is initialised:
  # >>    *n = (0, 0, 0)*
  #
  # > If any of the components is `NaN`, an error is thrown.
  constructor: (@x = 0, @y = 0, @z = 0) ->
    if isNaN(@x) or isNaN(@y) or isNaN(@z)
      throw new Error "Normal contains a NaN"

  # ### *Normal.FromNormal:*
  # > The **`Normal`** class provides a static function for initialising a **`Normal`** from another instance of the **`Normal`** class.
  @FromNormal: (n) ->
    return new Normal(n.x, n.y, n.z)

  # ### *Normal.FromVector:*
  # > The **`Normal`** class provides a static function for initialising a **`Normal`** from an instance of the **Vector** class.
  @FromVector: (v) ->
    return new Normal(v.x, v.y, v.z)
    
  # ___  
  # ## Prototypical Instance Functions:

  # These functions are attached to each instance of the **`Normal`** class - changing the function of one **`Normal`** changes the function on all other **`Normal`**s as well. These functions act on a **`Normal`** instance in-place - the original object is modified.

  # ### **Arithmetic methods**
  # Arithmetic with **`Normal`** instances is performed component-wise, for example:
  # >    *n + n' = (n.x + n'.x), (n.y + n'.y), (n.z + n'.z)*
  #
  # >    *n × 3' = (n.x × 3), (n.y × 3), (n.z × 3)*
  
  # > ### *add:*
  # >> **`add`** adds each of the *X*, *Y* and *Z* components of another **`Normal`** to the corresponding components of an instance of the **Normal** class.
  add: (n) ->
    @x += n.x
    @y += n.y
    @z += n.z
    return @
    
  # > ### *subtract:*
  # >> **`subtract`** subtracts each of the *X*, *Y* and *Z* components of another **`Normal`** from the corresponding components of an instance of the **`Normal`** class.
  subtract: (n) ->
    @x -= n.x
    @y -= n.y
    @z -= n.z
    return @
  
  # > ### *multiply:*
  # >> **`multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Normal`** class by a given scalar.
  multiply: (scale) ->
    @x *= scale
    @y *= scale
    @z *= scale
    return @

  # > ### *divide:*
  # >> **`divide`** divides each of the *X*, *Y* and *Z* components of an instance of the **`Normal`** class by a given scalar.
  #
  # >> An error is thrown if the scalar is `0`.
  #
  # >> One division and three multiplications are performed instead of three divisions for efficiency.
  divide: (scale) ->
    if scale is 0 
      throw new Error "Scale value is 0"
    inv = 1 / scale
    @x *= inv
    @y *= inv
    @z *= inv
    return @

  # ### *toArray:*
  # > **`toArray`** returns a **`Normal`** instance as an `Array` object of the form `[X, Y, Z]`.
  toArray: ->
    return [@x, @y, @z]

  # ### *equals:*
  # > **`equals`** checks a **`Normal`** for equality with another **`Normal`**. Two **`Normal`**s are equal if each of their *X*, *Y* and *Z* components are the same.
  equals: (n) ->
    if n.constructor? and n.constructor.name is "Normal"
      return @x is n.x and @y is n.y and @z is n.z
    else false

  # ___  
  # ### Static Functions:

  # These functions belong to the **`Normal`** class - any object arguments are not 
  # modified and a new object is always returned.
  
  # ### **Arithmetic methods**
  # Static implementations of basic arithmetic functions are also available. These functions
  # operate on existing **`Normal`** instances.

  # > ### *Normal.Add:*
  # >> **`Normal.Add`** adds each of the *X*, *Y* and *Z* components of another **`Normal`** to the corresponding components of an instance of the **`Normal`** class.
  @Add: (n1, n2) ->
    return new Normal(n1.x + n2.x, n1.y + n2.y, n1.z + n2.z)    
  
  # > ### *Normal.Subtract:*
  # >> **`Normal.Subtract`** subtracts each of the *X*, *Y* and *Z* components of another **`Normal`** from the corresponding components of an instance of the **`Normal`** class.
  @Subtract: (n1, n2) ->
    return new Normal(n1.x - n2.x, n1.y - n2.y, n1.z - n2.z)

  # > ### *Normal.Multiply:*
  # >> **`Normal.Multiply`** multiplies each of the *X*, *Y* and *Z* components of an instance of the **`Normal`** class by a given scalar.
  @Multiply: (n, scale) ->
    return new Normal(n.x * scale, n.y * scale, n.z * scale)

  # > ### *Normal.Divide:*
  # >> **`Normal.Divide`** divides each of the *X*, *Y* and *Z* components of an instance of the **`Normal`** class by a given scalar.
  #
  # >> An error is thrown if the scalar is `0`.
  #
  # >> One division and three multiplications are performed instead of three divisions for efficiency.
  @Divide: (n, scale) ->
    if scale is 0 then throw new Error "Scale value is 0"
    inv = 1 / scale
    return new Normal(n.x * inv, n.y * inv, n.z * inv)

  # ### *Normal.Negate:*
  # > **`Normal.Negate`** returns a **`Normal`** that points in the opposite direction to the given **`Normal`**, by negating each of the *X*, *Y* and *Z* components.
  @Negate: (n) ->
    return new Normal(-n.x, -n.y, -n.z)

  # ### *Normal.Equals:*
  # > **`Normal.Equals`** checks a **`Normal`** for equality with another **`Normal`**. Two **`Normal`**s are equal if each of their *X*, *Y* and *Z* components are the same.
  @Equals: (n1, n2) ->
    if n1.constructor? and n1.constructor.name is "Normal" and n2.constructor? and n2.constructor.name is "Normal"
      return n1.x is n2.x and n1.y is n2.y and n1.z is n2.z
    else false
    
  # ### *Normal.Clone:*
  # > **`Normal.Clone`** creates an exact copy of a **`Normal`**. A Class specific function is used for improved efficiency.
  @Clone: (n) ->
    return new Normal(n.x, n.y, n.z)

  # ### *Normal.Dot:*
  # > **`Normal.Dot`** computes the [**Dot Product**](http://en.wikipedia.org/wiki/Dot_product) of two **`Normal`** instances - or a **`Normal`** and a **`Vector`**. The **Dot Product** is defined for *a* and *b* as:
  # >>    *(a.x × b.x) + (a.y × b.y) + (a.z × b.z).*
  #
  # > The **Dot Product** has a simple relationship to the angle between two **`Normal`** instances:
  # >>    *(a &sdot; b) = || a || × || b || × cos(&theta;).*  
  @Dot: (a, b) ->
    return a.x * b.x + a.y * b.y + a.z * b.z

  # ### *Normal.AbsDot:*
  # > **`Normal.AbsDot`** computes the [**Absolute Value**](http://en.wikipedia.org/wiki/Absolute_value) of the **Dot Product** of two **`Normal`** instances - or a **Normal** and a **`Vector`**.
  @AbsDot: (a, b) ->
    return Math.abs Normal.Dot(a, b)
    
  # ### *Normal.Normalise:*
  # > **`Normal.Normalise`** normalises a **`Normal`**, returning a **`Normal`** that points in the same direction, but is of unit length.
  @Normalise: (n) ->
    return n.divide Math.sqrt(Math.pow(n.x, 2) + Math.pow(n.y, 2) + Math.pow(n.z, 2))
  
  # ### *Normal.FaceForward:*
  # > **`Normal.FaceForward`** checks if a **`Normal`** or a **`Vector`** is in the same hemisphere as another **`Normal`** or **`Vector`** and flips the first **`Normal`** or **`Vector`** if it isn't. This is useful for ensuring a surface normal is in the same hemisphere as an outgoing **`Ray`**.
  @FaceForward: (a, b) ->
    return (if Normal.Dot(a, b) < 0 then Normal.Negate(a) else a)

# ___

# ## <section id='ray'>Ray:</section>
# ___
# A **`Ray`** is a semi-infinte line specified by its origin and direction. It can be expressed in the parametric form:
# > *r(t) = origin + t × direction.*
class Ray  
  # ### *constructor:*
  # > A constructor function is defined for creating a new **`Ray`** with or without a parent **`Ray`**. The **`Ray`** constructor takes up to seven parameters:
  #
  # > * `origin` - the origin [**`Point`**](#point) from where the **`Ray`** leaves at time `0`
  #
  # > * `direction` - the [**`Vector`**](#vector) direction in which the **`Ray`** travels
  #
  # > * `minTime` - the minimum time for the **`Ray`** to travel before an intersection. Must be specified if `origin` and `direction` are
  #
  # > * `parent` (optional) - the parent for the **`Ray`** - defaults to `null`
  # 
  # > * `maxTime` (optional) - the maximum time for the **`Ray`** to travel to find intersections - defaults to `Infinity`.
  #
  # > * `time` (optional) - the current time for the **`Ray`**, to give a specific vaue along the parametric line - defaults to `0`.
  # 
  # > * `depth` (optional) - the depth for the **`Ray`**, based on how many generations of **`Ray`**s come before - defaults to `0`.
  constructor: (@origin, @direction, @minTime, @parent = null, @maxTime = Infinity, @time = 0, @depth = 0) ->
    if @origin? and @direction and not @minTime?
      throw Error "If origin and direction and specified, then minTime must be as well."
    if @parent?
      @time = @parent.time
      @depth = @parent.depth + 1
  
  # ___  
  # ### Prototypical Instance Functions:
 
  # These functions are attached to each instance of the **`Ray`** class - changing the function of one **`Ray`** changes the function on all other **`Ray`**s as well. These functions act on a **`Ray`** instance in place - the original object is modified.

  # ### *getPoint:*
  # > **`getPoint`** returns a new **`Point`** along the parameteric description of the **`Ray`** at a given time.
  getPoint: (time) ->
    return Point.AddVectorToPoint(@origin, @direction).multiply(time)

# ___

# ## <section id='raydiff'>RayDifferential:</section>
# ___
# A **`RayDifferential`** is a subclass of [**`Ray`**](#ray) that provides additional information about the two **`Ray`** instances that offset by one sample in the *X* and *Y* directions from the main **`Ray`**. It is used to perform better anti-aliasing on textures. 
class RayDifferential extends Ray
  # ___
  # ### Constructor Functions:
  
  # ### *constructor:*
  # > A constructor function is defined for creating a new **`RayDifferential`** with or without a parent **`Ray`**. The standard **`RayDifferential`** constructor takes up to seven parameters:
  #
  # > * `origin` - the origin [**`Point`**](#point) from where the **`RayDifferential`** leaves at time `0`
  #
  # > * `direction` - the [**`Vector`**](#vector) direction in which the **`RayDifferential`** travels
  #
  # > * `minTime` - the minimum time for the **`RayDifferential`** to travel before an intersection. Must be specified if origin and direction are
  #
  # > * `parent` (optional) - the parent for the **`RayDifferential`** - defaults to `null`
  # 
  # > * `maxTime` (optional) - the maximum time for the **`RayDifferential`** to travel to find intersections - defaults to `Infinity`
  #
  # > * `time` (optional) - the current time for the **`RayDifferential`**, to give a specific vaue along the parametric line - defaults to `0`
  # 
  # > * `depth` (optional) - the depth for the **`RayDifferential`**, based on how many generations of **`Ray`** come before - defaults to `0`
  constructor: (origin, direction, minTime, parent = null, maxTime = Infinity, time = 0, depth = 0) ->
    rayDiff = new Ray(origin, direction, minTime, parent, maxTime, time, depth)
    rayDiff.hasDifferentials = false
    rayDiff.rayXOrigin = null
    rayDiff.rayYOrigin = null
    rayDiff.rayXDirection = null
    rayDiff.rayYDirection = null
    (rayDiff[key] = @[key] for key of @)
    return rayDiff
    
  # ### *RayDifferential.FromRay:*
  # > The **`RayDifferential`** class provides a static function for initialising a **`RayDifferential`** from an instance of the **`Ray`** class.  
  @FromRay: (r) ->
    return new RayDifferential(r.origin, r.direction, r.minTime, r.parent, r.maxTime, r.time, r.depth)

  # ___  
  # ### Prototypical Instance Functions:    

  # These functions are attached to each instance of the **`RayDifferential`** class - changing the function of one **`RayDifferential`** changes the function on all other **`RayDifferential`**s as well. These functions act on a **`RayDifferential`** instance in place - the original object is modified.

  # ### *scaleDifferentials:*
  # > **`scaleDifferentials`** scales the difference betwen the original **`Ray`** and its differentials.
  scaleDifferentials: (s) ->
    @rayXOrigin = Point.AddVectorToPoint @origin, Point.SubtractPointFromPoint(@rayXOrigin, @origin).multiply(s)
    @rayYOrigin = Point.AddVectorToPoint @origin, Point.SubtractPointFromPoint(@rayYOrigin, @origin).multiply(s)
    @rayXDirection = Vector.Add @direction, Vector.Subtract(@rayXDirection, @direction).multiply(s)
    @rayYDirection = Vector.Add @direction, Vector.Subtract(@rayYDirection, @direction).multiply(s)
   
# ___

# ## <section id='bbox'>BoundingBox:</section>
# ___
# A **BoundingBox** is a 3-dimensional bounding volume that encloses an object. It is used to avoid doing unnecessary computation - for example, if a [**`Ray`**](#ray) doesn't pass through a **`BoundingBox`**, then there is no need to process any intersections with any of the objects inside the **`BoundingBox`**. 
#
# A **`BoundingBox`** is defined by two corner [**`Point`**](#point) instances, which implicitly describe the whole box.
class BoundingBox
  # ### *constructor:*
  # > A constructor function is defined for creating a new **`BoundingBox`** when given up to two **`Point`**s. 
  #
  # > When given two arguments, the constructor returns a **`BoundingBox`** with `pMin` set to the minimum *X*, *Y* and *Z* values from both **`Point`**s, and with `pMax` set to the maximum *X*, *Y* and *Z* values from both **`Point`**s.
  #
  # > When given a single argument, the constructor returns a **`BoundingBox`** that contains just that one **`Point`**.
  # 
  # > When given no arguments, the constructor returns a **`BoundingBox`** with `pMin` set to `Infinity`, and `pMax` set to `-Infinity`, which seems counter-intuitive but ensures correct behavious on operations like **`Union`** work correctly on the empty **`BoundingBox`**.
  constructor: (p1, p2) ->
    if p1? and p2?
      @pMin = new Point(Math.min(p1.x, p2.x), Math.min(p1.y, p2.y), Math.min(p1.z, p2.z))
      @pMax = new Point(Math.max(p1.x, p2.x), Math.max(p1.y, p2.y), Math.max(p1.z, p2.z))
    
    else if p1? and not p2? then return new BoundingBox(p1, p1)
    else if not p1? and p2? then return new BoundingBox(p2, p2)
    
    else
      @pMin = new Point(Infinity, Infinity, Infinity)
      @pMax = new Point(-Infinity, -Infinity, -Infinity)
  
  # ___  
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`BoundingBox`** class - changing the function of one **`BoundingBox`** changes the function on all other **`BoundingBox`**s as well. These functions act on a **`BoundingBox`** instance in place - the original object is modified.
  
  # ### *expand:*
  # > **`expand`** pads the original **`BoundingBox`** instance by a constant factor `delta` in all directions.
  expand: (delta) ->
    @pMin.subtractVector new Vector(delta, delta, delta)
    @pMax.addVector new Vector(delta, delta, delta)
    return @

  # ### *surfaceArea:*
  # > **`surfaceArea`** returns the total surface area of the six faces of the original **`BoundingBox`** instance.
  surfaceArea: ->
    d = Point.SubtractPointFromPoint @pMax, @pMin
    return 2 * (d.x * d.y + d.x * d.z + d.y * d.z)

  # ### *volume:*
  # > **`volume`** returns the total internal volume of the original **`BoundingBox`** instance.
  volume: ->
    d = Point.SubtractPointFromPoint @pMax, @pMin
    return d.x * d.y * d.z
  
  # ### *maximumExtent:*
  # > **`maximumExtent`** returns which of the tree lengths of the original **`BoundingBox`** instance is longest.
  maximumExtent: ->
    d = Point.SubtractPointFromPoint @pMax, @pMin
    if d.x > d.y and d.x > d.z then return 0;
    else if d.y > d.z then return 1;
    else return 2;

  # ### *toArray:*
  # > **`toArray`** returns the original **`BoundingBox`** instance as an `Array` object of the form `[pMin, pMax]`. 
  toArray: ->
    return [@pMin, @pMax]
  
  # ### *boundingSphere:*
  # > **`boundingSphere`** returns the center and radius of a sphere that competely encapsulates this **`BoundingBox`**.
  boundingSphere: ->
    center = Point.AddPointToPoint Point.Multiply(@pMin, 0.5), Point.Multiply(@pMax, 0.5)
    radius = if BoundingBox.Inside this, center then Point.Distance center, @pMax else 0
    return [center, radius]
  
  # ___  
  # ### Static Functions: 

  # These functions belong to the **`BoundingBox`** class - any object arguments are not 
  # modified and a new object is always returned.
      
  # ### *BoundingBox.UnionBBoxAndPoint:*
  # > **`BoundingBox.UnionBBoxAndPoint`** returns a new **`BoundingBox** that encompasses a given **`BoundingBox`** and **`Point`**.
  @UnionBBoxAndPoint: (bbox, p) ->
    return new BoundingBox(new Point(Math.min(bbox.pMin.x, p.x), Math.min(bbox.pMin.y, p.y), Math.min(bbox.pMin.z, p.z)),
                           new Point(Math.max(bbox.pMax.x, p.x), Math.max(bbox.pMax.y, p.y), Math.max(bbox.pMax.z, p.z)))
  
  # ### *BoundingBox.UnionBBoxAndBBox:*
  # > **`BoundingBox.UnionBBoxAndBBox`** returns a new **`BoundingBox`** that encompasses a two given **`BoundingBox`** instances.
  @UnionBBoxAndBBox: (bbox1, bbox2) ->
    return new BoundingBox(new Point(Math.min(bbox1.pMin.x, bbox2.pMin.x), Math.min(bbox1.pMin.y, bbox2.pMin.y), Math.min(bbox1.pMin.z, bbox2.pMin.z)),
                           new Point(Math.max(bbox1.pMax.x, bbox2.pMax.x), Math.max(bbox1.pMax.y, bbox2.pMax.y), Math.max(bbox1.pMax.z, bbox2.pMax.z)))
  
  # ### *BoundingBox.Equals:*
  # > **`BoundingBox.Equals`** checks if two **`BoundingBox`**es are equal to one another. Two **`BoundingBox`**es are equal if both of their `pMin` components are the same, and both of their `pMax` components are the same.
  @Equals: (bbox1, bbox2) ->
    if bbox1.constructor.name is "BoundingBox" and bbox2.constructor.name is "BoundingBox"
      return Point.Equals bbox1.pMin, bbox2.pMin and Point.Equals bbox1.pMax, bbox2.pMax
    return false
    
  # ### *BoundingBox.Overlaps:*
  # > **`BoundingBox.Overlaps`** checks if two **`BoundingBox`**es overlap one another.
  @Overlaps: (bbox1, bbox2) ->
    return ((bbox1.pMax.x >= bbox2.pMin.x) and (bbox1.pMin.x <= bbox2.pMax.x)) and 
           ((bbox1.pMax.y >= bbox2.pMin.y) and (bbox1.pMin.y <= bbox2.pMax.y)) and 
           ((bbox1.pMax.z >= bbox2.pMin.z) and (bbox1.pMin.z <= bbox2.pMax.z))
  
  # ### *BoundingBox.Inside:*
  # > **`BoundingBox.Inside`** checks if a **`Point`** lies inside a given **`BoundingBox`**.         
  @Inside: (bbox, p) ->
    return (p.x >= bbox.pMin.x and p.x <= bbox.pMax.x and p.y >= bbox.pMin.y and p.y <= bbox.pMax.y and p.z >= bbox.pMin.z and p.z <= bbox.pMax.z)
  
  # ### *BoundingBox.LinearInterpolation:*
  # > **`BoundingBox.LinearInterpolation`** linearly interpolates between the corners of a given **`BoundingBox`**, where `bbox.pMin` has an offset of `(0, 0, 0)` and `bbox.pMax` has an offset of `(1, 1, 1)`.
  @LinearInterpolation: (bbox, tx, ty, tz) ->
    return new Point(MathFunctions.LinearInterpolation tx, bbox.pMin.x, bbox.pMax.x,
                     MathFunctions.LinearInterpolation ty, bbox.pMin.y, bbox.pMax.y,
                     MathFunctions.LinearInterpolation tz, bbox.pMin.z, bbox.pMax.z)
  
  # ### *BoundingBox.Offset:*
  # > **`BoundingBox.Offset`** returns the offset of a point against a given **`BoundingBox`**, where `(0, 0, 0)` represents `bbox.pMin`, and `(1, 1, 1)` represents `bbox.pMax`.
  @Offset: (bbox, p) ->
    return new Vector((p.x - bbox.pMin.x) / (bbox.pMax.x - bbox.pMin.x),
                      (p.y - bbox.pMin.y) / (bbox.pMax.y - bbox.pMin.y),
                      (p.z - bbox.pMin.z) / (bbox.pMax.z - bbox.pMin.z))
                      
# ___
# ## Exports: 

# The [**`Vector`**](#vector), [**`Point`**](#point), [**`Normal`**](#normal), [**`Ray`**](#ray), [**`RayDifferential`**](#raydiff) and [**`BoundingBox`**](#bbox) classes are added to the global `root` object.
root = exports ? this
root.Vector = Vector
root.Point = Point
root.Normal = Normal
root.Ray = Ray
root.RayDifferential = RayDifferential
root.BoundingBox = BoundingBox