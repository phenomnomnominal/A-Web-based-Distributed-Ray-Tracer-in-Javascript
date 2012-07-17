# *camera.coffee* contains generic camera constructs, specifically the [**`Camera`**](#camera) interface and two subclasses which implement it:
#
# * [**`OrthographicCamera`**](#orthographic)
#
# * [**`PerspectiveCamera`**](#perspective)
#
# As well as this, is contains the [**`Film`**](#film) class, which acts as the cameras sensor and captures the resulting image from the rendering.

# ___
# ## Requires:

# Classes in *camera.coffee* require access to classes from other packages and files:

# * From [*geometry/geometry.coffee:*](geometry.html)
Geometry = this.Geometry ? if require? then require './geometry/geometry'

# > * [**`Vector`**](geometry.html#vector)
Vector = this.Vector ? Geometry.Vector

# > * [**`Point`**](geometry.html#point)
Point = this.Point ? Geometry.Point

# * From [*geometry/transform.coffee:*](transform.html)

# > * [**`Transform`**](transform.html#transform)
Transform = this.Transform ? if require? then (require './geometry/transform').Transform

# ___

# ## <section id='camera'>Camera:</section>
# ___
# **`Camera`** is an abstract base class which defines the interface that all **`Camera`** subclasses must implement.
class Camera
  # ### *constructor:*
  # > The **`Camera`** constructor requires several parameters that are appropriate for all **`Camera`** types:
  #
  # > * The `CameraToWorld` [**`AnimatedTransform`**](animatedTransform.html/#animatedTransform)
  # 
  # > * The `ShutterOpen` and `ShutterClose` times
  #
  # > * An instance of the [**`Film`**](#film) class
  constructor: (@CameraToWorld, @ShutterOpen, @ShutterClose, @Film) ->
    if @CameraToWorld.hasScale() 
      throw Error "CameraToWorld shouldn't have any scale factors in it."

  # ___
  # ### Prototypical Instance Functions:
  
  # These functions are attached to each instance of the **`Camera`** class - changing the function of one **`Camera`** changes the function on all other **`Camera`**s as well. 

  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given image sample.
  # > It is required to be overridden by all subclasses of **`Camera`** class.
  generateRay: (sample) -> 
    throw Error "Not Implemented - GenerateRay must be implemented by Camera subclasses."
  
  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main **`Ray`** like **`generateRay`** but also generates corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y* directions.
  generateRayDifferential: (sample) ->
    [weight, rayDiff] = GenerateRay(sample)
    
    shift = sample
    shift.imageX++
    [weightX, rayX] = GenerateRay(shift)
    rayDiff.rayXOrigin = rayX.origin
    rayDiff.rayXDirection = rayX.direction
    shift.imageX--
    
    shift.imageY++
    [weightY, rayY] = GenerateRay(shift)
    rayDiff.rayYOrigin = rayY.origin
    rayDiff.rayYDirection = rayY.direction
    
    if weightX is 0 or weightY is 0
      return 0
    rayDiff.hasDifferentials = true
    return [weight, rayDiff]

# ___

# ## <section id='projective'>ProjectiveCamera:</section>
# ___
# **`ProjectiveCamera`** extends the [**`Camera`**](#camera) base class to provide a common base for all *Projective* 
# camera types.
class ProjectiveCamera extends Camera
  # ### *constructor:*
  # > The **`ProjectiveCamera`** constructor requires several parameters in addition to those required by the base class:
  #
  # > * The `ProjectiveTransform` [**`Transform`**](transform.html#transform)
  # 
  # > * The `ScreenWindow`
  #
  # > * The `LensRadius` and `FocalDistance` for depth of field
  constructor: (CameraToWorld, ProjectiveTransform, ScreenWindow, ShutterOpen, ShutterClose, LensRadius, FocalDistance, Film) ->
    super(CameraToWorld, ShutterOpen, ShutterClose, Film)
    @CameraToScreen = ProjectiveTransform
    @ScreenToRaster = Transform.Multiply(Transform.Scale(Film.xResolution, Film.yResolution, 1), 
                                         Transform.Scale(1 / (ScreenWindow[1] - ScreenWindow[0]), 1 / (ScreenWindow[2] - ScreenWindow[3]), 1),
                                         Transform.Translate(new Vector(-ScreenWindow[0], -ScreenWindow[3], 0)))
    @RasterToScreen = Transform.InverseTransform(@ScreenToRaster)
    @RasterToCamera = Transform.Multiply(Transform.InverseTransform(@CameraToScreen), @RasterToScreen)
    @LensRadius = LensRadius
    @FocalDistance = FocalDistance
    
# ___

# ## <section id='orthographic'>OrthographicCamera:</section>
# ___
# **`OrthographicCamera`** extends the [**`ProjectiveCamera`**](#projective)) base class and is based on the [**orthographic projection transformation**](http://en.wikipedia.org/wiki/Orthographic_projection).
class OrthographicCamera extends ProjectiveCamera
  # ### *constructor:*
  # > The **`OrthographicCamera`** constructor requires 2 additional paramaters to those required by the **`ProjectiveCamera`** class:
  #
  # > * The *Z* value for the `Near` projection plane
  # 
  # > * The *Z* value for the `Far` projection plane
  constructor: (CameraToWorld, Near = 0, Far = 1, ScreenWindow, ShutterOpen, ShutterClose, LensRadius, FocalDistance, Film) ->
    super(CameraToWorld, Transform.Orthographic(Near, Far), ScreenWindow, 
          ShutterOpen, ShutterClose, LensRadius, FocalDistance, Film)
    @dxCamera = Transform.TransformVector @RasterToCamera, new Vector(1, 0, 0)
    @dyCamera = Transform.TransformVector @RasterToCamera, new Vector(0, 1, 0)
    
  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`OrthographicCamera`** class - changing the function of one **`OrthographicCamera`** changes the function on all other **`OrthographicCamera`**s as well.
  
  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given image sample.
  # > It is required to be overridden by all subclasses of **`Camera`** class.
  generateRay: (sample) ->
    RasterPoint = new Point(sample.imageX, sample.imageY, 0)
    CameraPoint = Transform.TransformPoint(@RasterToCamera, RasterPoint)
    ray = new Ray(CameraPoint, new Vector(0, 0, 1), 0, Infinity)
    `// TODO 
    // if @LensRadius > 0
    //   ray = Ray.DepthOfField(sample, ray)`
    ray.time = MathFunctions.LinearInterpolation(sample.time, shutterOpen, shutterClose)
    ray = Transform.TransformRay(@CameraToWorld, ray)
    return [1, ray]
    
  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main **`Ray`** like **`generateRay`** but also generates corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y* directions.
  generateRayDifferential: (sample) ->
    RasterPoint = new Point(sample.imageX, sample.imageY, 0)
    CameraPoint = Transform.TransformPoint(@RasterToCamera, RasterPoint)
    rayDiff = new RayDifferential(CameraPoint, new Vector(0, 0, 1), 0, Infinity)
    `// TODO
    // if @LensRadius > 0
    //   rayDiff = Ray.DepthOfField(sample, rayDiff)`
    rayDiff.time = MathFunctions.LinearInterpolation(sample.time, shutterOpen, shutterClose)
    rayDiff.rayXOrigin = Point.AddVectorToPoint(rayDiff.origin, @dxCamera)
    rayDiff.rayYOrigin = Point.AddVectorToPoint(rayDiff.origin, @dyCamera)
    rayDiff.rayXDirection = rayDiff.rayYDirection = rayDiff.direction
    rayDiff.hasDifferentials = true
    rayDiff = Transform.TransformRayDifferential(@CameraToWorld, ray)
    return [1, rayDiff]

# ___

# ## <section id='perspective'>PerspectiveCamera:</section>
# ___
# **`PerspectiveCamera`** extends the [**`ProjectiveCamera`**](#projective) base class and is based on the 
# [**perspective projection transformation**](http://en.wikipedia.org/wiki/Camera_matrix).
class PerspectiveCamera extends ProjectiveCamera
  # ### *constructor:*
  # > The **`PerspectiveCamera`** constructor requires 3 additional paramaters to those required by the **`ProjectiveCamera`** class:
  #  
  # > * The `FieldOfView` angle
  #
  # > * The *Z* value for the `Near` projection plane
  # 
  # > * The *Z* value for the `Far` projection plane
  #
  constructor: (CameraToWorld, FieldOfView, Near = 1e-2, Far = 1000, ScreenWindow, ShutterOpen, ShutterClose, LensRadius = 0, FocalDistance = 0, Film) ->
    super(CameraToWorld, Transform.Perspective(FieldOfView, Near, Far), ScreenWindow, 
                                        ShutterOpen, ShutterClose, LensRadius, FocalDistance, Film)
    @dxCamera = Point.SubtractPointFromPoint(Transform.TransformPoint(@RasterToCamera, new Point(1, 0, 0)),
                                             Transform.TransformPoint(@RasterToCamera, new Point(0, 0, 0)))
    @dyCamera = Point.SubtractPointFromPoint(Transform.TransformPoint(@RasterToCamera, new Point(0, 1, 0)),
                                             Transform.TransformPoint(@RasterToCamera, new Point(0, 0, 0)))
    
  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`ProjectiveCamera`** class - changing the function of one **`ProjectiveCamera`** changes the function on all other **`ProjectiveCamera`**s as well.
    
  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given image sample.
  # > It is required to be overridden by all subclasses of **`Camera`** class.
  generateRay: (sample, ray) ->
    RasterPoint = new Point(sample.imageX, sample.imageY, 0)
    CameraPoint = Transform.TransformPoint(@RasterToCamera, RasterPoint)
    ray = new Ray(new Point(0, 0, 0), Vector.Normalize(Vector.FromPoint(CameraPoint)), 0, Infinity)
    `// TODO 
    // if @LensRadius > 0
    //   ray = Ray.DepthOfField(sample, ray)`
    ray.time = MathFunctions.LinearInterpolation(sample.time, shutterOpen, shutterClose)
    ray = Transform.TransformRay(@CameraToWorld, ray)
    return [1, ray]

  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main **`Ray`** like **`generateRay`** but also generates corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y* directions.
  generateRayDifferential: (sample, rayDiff) ->
    RasterPoint = new Point(sample.imageX, sample.imageY, 0)
    CameraPoint = Transform.TransformPoint(@RasterToCamera, RasterPoint)
    rayDiff = new RayDifferential(new Point(0, 0, 0), Vector.Normalize(Vector.FromPoint(CameraPoint)), 0, Infinity)
    `// TODO
    // if @LensRadius > 0
    //   rayDiff = Ray.DepthOfField(sample, rayDiff)`
    rayDiff.rayXOrigin = rayDiff.rayYOrigin = rayDiff.origin
    rayDiff.rayXDirection = Vector.Normalize(Vector.FromPoint(CameraPoint).add(dxCamera))
    rayDiff.rayYDirection = Vector.Normalize(Vector.FromPoint(CameraPoint).add(dyCamera))
    rayDiff.time = MathFunctions.LinearInterpolation(sample.time, shutterOpen, shutterClose)
    rayDiff = Transform.TransformRayDifferential(@CameraToWorld, rayDiff)
    rayDiff.hasDifferentials = true
    return [1, rayDiff]
    
# ___

# ## <section id='film'>Film:</section>
# ___
# **`Film`** is an abstract base class which defines the interface that all film subclasses must implement.
class Film
  
  # # TODO
  
  constructor: (@xResolution, @yResolution) ->
    
# ___
# ## Exports:

# The [**`OrthographicCamera`**](#orthographics), [**`PerspectiveCamera`**](#perspective) and [**`Film`**](#film) classes are added to the global *root* object.
root = exports ? this
root.OrthographicCamera = OrthographicCamera
root.PerspectiveCamera = PerspectiveCamera
root.Film = Film