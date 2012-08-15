class NotImplementedError extends Error

# *camera.coffee* contains generic camera constructs, specifically the
#[**`Camera`**](#camera) interface and two subclasses which implement it:
#
# * [**`OrthographicCamera`**](#orthographic)
#
# * [**`PerspectiveCamera`**](#perspective)
#
# As well as this, it contains the [**`Film`**](#film) class, which acts as the
# [**`Camera`**](#camera)'s sensor and captures the resulting image from the
# rendering.

# ___

# ## <section id='camera'>Camera:</section>
# ___
# **`Camera`** is an abstract base class that defines an interface which
# all **`Camera`** subclasses must implement.
class Camera
  # ### *constructor:*
  # > The **`Camera`** constructor requires four parameters
  # that are appropriate for all **`Camera`** types:
  #
  # > * A camera-space to world-space transformation: `cameraToWorld` -
  # must be an [**`AnimatedTransform`**](animatedTransform.html/#animT)
  #
  # > * The time when the camera shutter opens: `shutterOpen`
  #
  # > * The time when the camera shutter closes: `shutterClose`
  #
  # > * The film of the camera - `film` - must be an instance of the
  # [**`Film`**](#film) class
  #
  # > If these are not supplied or are of the incorrect type, the constructor
  # will throw an **`Error`**.
  constructor: (@cameraToWorld, @shutterOpen, @shutterClose, @film) ->
    unless @cameraToWorld?
      throw Error 'Camera Constructor Error: cameraToWorld must be defined.'
    unless @cameraToWorld.constructor.name is 'AnimatedTransform'
      throw Error 'Camera Constructor Error: cameraToWorld must be an AnimatedTransform.'
    unless @shutterOpen?
      throw Error 'Camera Constructor Error: shutterOpen must be defined.'
    unless _.isNumber @shutterOpen
      throw Error 'Camera Constructor Error: shutterOpen must be a Number.'
    unless @shutterClose?
      throw Error 'Camera Constructor Error: shutterClose must be defined.'
    unless _.isNumber @shutterClose
      throw Error 'Camera Constructor Error: shutterClose must be a Number.'
    unless @film?
      throw Error 'Camera Constructor Error: film must be defined.'
    unless @film.constructor.name is 'Film'
      throw Error 'Camera Constructor Error: film must be a Film.'
      
    if @cameraToWorld.hasScale()
      throw Error 'Camera Constructor Error: cameraToWorld shouldn\'t have any scale factors in it.'

  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the **`Camera`**
  # class - changing the function of one **`Camera`** changes the
  # function on all other **`Camera`**s as well.

  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given
  # image sample. It is required to be overridden by all subclasses of
  # **`Camera`** class.
  generateRay: (sample) ->
    throw Error 'Not Implemented Error: generateRay must be implemented by Camera subclasses.'

  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main
  # [**`Ray`**](geometry.html#ray) like **`generateRay`** but also generates
  # corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y*
  # directions.
  generateRayDifferential: (sample) ->
    [weight, rayDiff] = @generateRay sample
    
    shift = sample
    shift.imageX++
    [weightX, rayX] = @generateRay shift
    rayDiff.rayXOrigin = rayX.origin
    rayDiff.rayXDirection = rayX.direction
    shift.imageX--
    
    shift.imageY++
    [weightY, rayY] = @generateRay shift
    rayDiff.rayYOrigin = rayY.origin
    rayDiff.rayYDirection = rayY.direction
    
    if weightX is 0 or weightY is 0
      return 0
    rayDiff.hasDifferentials = true
    return [weight, rayDiff]

# ___

# ## <section id='projective'>ProjectiveCamera:</section>
# ___
# **`ProjectiveCamera`** extends the [**`Camera`**](#camera) base class to
# provide a common base for all *Projective* camera types.
class ProjectiveCamera extends Camera
  # ### *constructor:*
  # > The **`ProjectiveCamera`** constructor requires four
  # parameters in addition to those required by the base
  # class:
  #
  # > * A mapping from 3D-space to 2D-spcae: `projectiveTransform` -
  # must be a [**`Transform`**](transform.html#transform)
  #
  # > * The screen space extent of the image: `screenWindow`
  #
  # > * The radius of the camera lens: `lensRadius`
  #
  # > * the focal distance of the camera lens: `focalDistance`
  #
  # > If these are not supplied or are of the incorrect type, the constructor
  # will throw an **`Error`**.
  constructor: (cameraToWorld, shutterOpen, shutterClose, film,
            projectiveTransform, screenWindow, @lensRadius, @focalDistance) ->
    
    super(cameraToWorld, shutterOpen, shutterClose, film)
    
    unless projectiveTransform?
      throw Error 'ProjectiveCamera Constructor Error: projectiveTransform must be defined.'
    unless projectiveTransform.constructor.name is 'Transform'
      throw Error 'ProjectiveCamera Constructor Error: projectiveTransform must be a Transform.'
    unless screenWindow?
      throw Error 'ProjectiveCamera Constructor Error: screenWindow must be defined.'
    unless _.isArray screenWindow
      throw Error 'ProjectiveCamera Constructor Error: screenWindow must be an Array.'
    unless @lensRadius?
      throw Error 'ProjectiveCamera Constructor Error: lensRadius must be defined.'
    unless _.isNumber @lensRadius
      throw Error 'ProjectiveCamera Constructor Error: lensRadius must be a Number.'
    unless @focalDistance?
      throw Error 'ProjectiveCamera Constructor Error: focalDistance must be defined.'
    unless _.isNumber @focalDistance
      throw Error 'ProjectiveCamera Constructor Error: focalDistance must be a Number.'
    
    @cameraToScreen = projectiveTransform
    scaleRas = Transform.Scale(film.xResolution, film.yResolution, 1)
    scaleRes = Transform.Scale(1 / (screenWindow[1] - screenWindow[0]),
                               1 / (screenWindow[2] - screenWindow[3]),
                               1)
    translate = Transform.Translate(new Vector(-screenWindow[0],
                                               -screenWindow[3],
                                               0))
    @screenToRaster = Transform.Multiply([scaleRas, scaleRes, translate]...)
    @rasterToScreen = Transform.InverseTransform(@screenToRaster)
    screenToCamera = Transform.InverseTransform(@cameraToScreen)
    @rasterToCamera = Transform.Multiply [screenToCamera, @rasterToScreen]...
    
# ___

# ## <section id='orthographic'>OrthographicCamera:</section>
# ___
# **`OrthographicCamera`** extends the [**`ProjectiveCamera`**](#projective)
# base class and is based on the **[orthographic][]** transformation.
#
# <!--- URLs -->
# [orthographic]: http://en.wikipedia.org/wiki/Orthographic_projection
class OrthographicCamera extends ProjectiveCamera
  # ### *constructor:*
  # > The **`OrthographicCamera`** constructor takes two
  # optional parameters in addition to those required by
  # the **`ProjectiveCamera`** class:
  #
  # > * A *Z* value for the near projection plane: `near` - defaults to `0`
  #
  # > * A *Z* value for the far projection plane: `far` - defaults to `1`
  #
  # > If these are supplied by the user and are of the incorrect type, the
  # constructor will throw an **`Error`**.
  constructor: (cameraToWorld, shutterOpen, shutterClose, film,
                near = 0, far = 1, screenWindow, lensRadius, focalDistance) ->

    unless _.isNumber near
      throw Error 'OrthographicCamera Constructor Error: near must be a Number.'
    unless _.isNumber far
      throw Error 'OrthographicCamera Constructor Error: far must be a Number.'
    
    projectiveTransform = Transform.Orthographic(near, far)

    super(cameraToWorld, shutterOpen, shutterClose, film,
          projectiveTransform, screenWindow, lensRadius, focalDistance)
          
    @dxCamera = Transform.TransformVector @rasterToCamera, new Vector(1, 0, 0)
    @dyCamera = Transform.TransformVector @rasterToCamera, new Vector(0, 1, 0)
    
  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the
  # **`OrthographicCamera`** class - changing the function of one
  # **`OrthographicCamera`** changes the function on all other
  # **`OrthographicCamera`**s as well.
  
  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given
  # image sample. It is required to be overridden by all
  # subclasses of [**`Camera`**](#camera) class.
  generateRay: (sample) ->
    rasterPoint = new Point(sample.imageX, sample.imageY, 0)
    cameraPoint = Transform.TransformPoint @rasterToCamera, rasterPoint
    ray = new Ray(cameraPoint, new Vector(0, 0, 1), 0, null, Infinity)
    `// TODO
    // if @lensRadius > 0
    //   ray = Ray.DepthOfField(sample, ray)`
    ray.time = MathFunctions.LinearInterpolation(sample.time,
                                                 @shutterOpen,
                                                 @shutterClose)
    ray = AnimatedTransform.TransformRay @cameraToWorld, ray
    return [1, ray]
    
  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main
  # [**`Ray`**](geometry.html#ray) like **`generateRay`** but also generates
  # corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y*
  # directions.
  generateRayDifferential: (sample) ->
    rasterPoint = new Point(sample.imageX, sample.imageY, 0)
    cameraPoint = Transform.TransformPoint @rasterToCamera, rasterPoint
    
    rayDirection = new Vector(0, 0, 1)
    rayDiff = new RayDifferential(cameraPoint, rayDirection, 0, null, Infinity)
    
    `// TODO
    // if @lensRadius > 0
    //   rayDiff = Ray.DepthOfField(sample, rayDiff)`
    
    rayDiff.time = MathFunctions.LinearInterpolation(sample.time,
                                                     @shutterOpen,
                                                     @shutterClose)
    rayDiff.rayXOrigin = Point.AddVectorToPoint(rayDiff.origin, @dxCamera)
    rayDiff.rayYOrigin = Point.AddVectorToPoint(rayDiff.origin, @dyCamera)
    rayDiff.rayXDirection = rayDiff.rayYDirection = rayDiff.direction
    
    rayDiff.hasDifferentials = true
    rayDiff = AnimatedTransform.TransformRayDiff @cameraToWorld, rayDiff
    return [1, rayDiff]

# ___

# ## <section id='perspective'>PerspectiveCamera:</section>
# ___
# **`PerspectiveCamera`** extends the [**`ProjectiveCamera`**](#projective)
# base class and is based on the **[perspective][]** transformation.
#
# <!--- URLs -->
# [perspective]: http://en.wikipedia.org/wiki/Camera_matrix
class PerspectiveCamera extends ProjectiveCamera
  # ### *constructor:*
  # > The **`PerspectiveCamera`** constructor takes three
  # optional parameters in addition to those required by
  # the **`ProjectiveCamera`** class:
  #
  # > * The field of view angle: `fieldOfView`
  #
  # > * A *Z* value for the near projection plane: `near` - defaults to `0.01`
  #
  # > * A *Z* value for the far projection plane: `far` - defaults to `1000`
  #
  # > If these are supplied by the user and are of the incorrect type, the
  # constructor will throw an **`Error`**.
  constructor: (cameraToWorld, shutterOpen, shutterClose, film,
                fieldOfView = 45, near = 1e-2, far = 1000,
                screenWindow, lensRadius, focalDistance) ->
    
    unless _.isNumber fieldOfView
      throw Error 'PerspectiveCamera Constructor Error: fieldOfView must be a Number.'
    unless _.isNumber near
      throw Error 'PerspectiveCamera Constructor Error: near must be a Number.'
    unless _.isNumber far
      throw Error 'PerspectiveCamera Constructor Error: far must be a Number.'
    
    projectiveTransform = Transform.Perspective(fieldOfView, near, far)

    super(cameraToWorld, shutterOpen, shutterClose, film,
          projectiveTransform, screenWindow, lensRadius, focalDistance)

    x = new Point(1, 0, 0)
    y = new Point(0, 1, 0)
    origin = new Point(0, 0, 0)
    transformedX = Transform.TransformPoint @rasterToCamera, x
    transformedY = Transform.TransformPoint @rasterToCamera, y
    transformedOrigin = Transform.TransformPoint @rasterToCamera, origin
    @dxCamera = Point.SubtractPointFromPoint transformedX, transformedOrigin
    @dyCamera = Point.SubtractPointFromPoint transformedY, transformedOrigin

  # ___
  # ### Prototypical Instance Functions:

  # These functions are attached to each instance of the
  # **`ProjectiveCamera`** class - changing the function of one
  # **`ProjectiveCamera`** changes the function on all other
  # **`ProjectiveCamera`**s as well.

  # ### *generateRay:*
  # > **`generateRay`** generates a [**`Ray`**](geometry.html#ray) for a given
  # image sample. It is required to be overridden by all
  # subclasses of **`Camera`** class.
  generateRay: (sample, ray) ->
    rasterPoint = new Point(sample.imageX, sample.imageY, 0)
    cameraPoint = Transform.TransformPoint @rasterToCamera, rasterPoint

    rayDirection = Vector.Normalise Vector.FromPoint(cameraPoint)
    ray = new Ray(new Point(0, 0, 0), rayDirection, 0, Infinity)
    
    `// TODO
    // if @LensRadius > 0
    //   ray = Ray.DepthOfField(sample, ray)`

    ray.time = MathFunctions.LinearInterpolation(sample.time,
                                                 @shutterOpen,
                                                 @shutterClose)
    ray = AnimatedTransform.TransformRay @cameraToWorld, ray
    return [1, ray]

  # ### *generateRayDifferential:*
  # > **`generateRayDifferential`** generates a main
  # [**`Ray`**](geometry.html#ray) like **`generateRay`** but also generates
  # corresponding **`Ray`**s for pixels shifted one sample in the *X* and *Y*
  # directions.
  generateRayDifferential: (sample, rayDiff) ->
    rasterPoint = new Point(sample.imageX, sample.imageY, 0)
    cameraPoint = Transform.TransformPoint @rasterToCamera, rasterPoint

    rayOrigin = new Point(0, 0, 0)
    rayDirection = Vector.Normalise Vector.FromPoint(cameraPoint)
    rayDiff = new RayDifferential(rayOrigin, rayDirection, 0, Infinity)

    `// TODO
    // if @LensRadius > 0
    //   rayDiff = Ray.DepthOfField(sample, rayDiff)`

    rayDiff.rayXOrigin = rayDiff.rayYOrigin = rayDiff.origin
    vectorDX = Vector.FromPoint(cameraPoint).add(@dxCamera)
    vectorDY = Vector.FromPoint(cameraPoint).add(@dyCamera)
    rayDiff.rayXDirection = Vector.Normalise vectorDX
    rayDiff.rayYDirection = Vector.Normalise vectorDY
    rayDiff.time = MathFunctions.LinearInterpolation(sample.time,
                                                     @shutterOpen,
                                                     @shutterClose)
    rayDiff = AnimatedTransform.TransformRayDiff(@cameraToWorld, rayDiff)
    rayDiff.hasDifferentials = true
    return [1, rayDiff]
    
# ___

# ## <section id='film'>Film:</section>
# ___
# **`Film`** is an abstract base class which defines the interface that
# all film subclasses must implement.
class Film
  
  constructor: (@xResolution, @yResolution) ->
    
  addSample: ->
    throw NotImplementedError '`addSample` must be implemented by Film subclasses.'
    
  splat: ->
    throw NotImplementedError '`splat` must be implemented by Film subclasses.'
  
  getSampleExtent: ->
    throw NotImplementedError '`getSampleExtent` must be implemented by Film subclasses.'
    
  getPixelExtent: ->
    throw NotImplementedError '`getPixelExtent` must be implemented by Film subclasses.'
  
  updateDisplay: ->
    console.info '`updateDisplay` can optionally be implemented by Film subclasses.'
    
  writeImage: ->
    throw NotImplementedError '`writeImage` must be implemented by Film subclasses.'

class ImageFilm extends Film
  FILTER_TABLE_SIZE = 16
  
  constructor: (xResolution, yResolution, @filter, cropWindow) ->
    super(xResolution, yResolution)
    @cropWindow = (val for val in cropWindow)
    @xPixelStart = Math.ceil(@xResolution * @cropWindow[0])
    @xPixelCount = Math.max(1, Math.ceil(@xResolution * @cropWindow[1]) - @xPixelStart)
    @yPixelStart = Math.ceil(@yResolution * @cropWindow[2])
    @yPixelCount = Math.max(1, Math.ceil(@yResolution * @cropWindow[3]) - @yPixelStart)
    @pixels = ([] for x in [0...@xPixelCount])
    
    
    @filterTable = []
    
    for y in [0...FILTER_TABLE_SIZE]
      fy = (y + 0.5) * @filter.yWidth / FILTER_TABLE_SIZE
      for x in [0...FILTER_TABLE_SIZE]
        fx = (x + 0.5) * @filter.xWidth / FILTER_TABLE_SIZE
        @filterTable.push @filter.evaluate(fx, fy)
  
  addSample: (sample, spectrum) ->
    dImageX = sample.imageX - 0.5
    dImageY = sample.imageY - 0.5
    x0 = Math.ceil dImageX - filter.xWidth
    x1 = Math.floor dImageX + filter.xWidth
    y0 = Math.ceil dImageY - filter.yWidth
    y1 = Math.floor dImageY + filter.yWidth
    
    x0 = Math.max x0, @xPixelStart
    x1 = Math.min x1, @xPixelStart + @xPixelCount - 1
    y0 = Math.max y0, @yPixelStart
    y1 = Math.min y1, @yPixelStart + @yPixelCount - 1
    if x1 - x0 < 0 or y1 - y0 < 0
      return
    xyz = spectrum.ToXYZ()
    [sX, sY, sZ] = xyz

    ifx = []
    for x in [x0..x1]
      fx = Math.abs (x - dImageX) * @filter.invXWidth * FILTER_TABLE_SIZE
      ifx[x - x0] = Math.min(Math.floor(fx), FILTER_TABLE_SIZE - 1)
    ify = []
    for y in [y0..y1]
      fy = Math.abs (y - dImageY) * @filter.invYWidth * FILTER_TABLE_SIZE
      ify[y - y0] = Math.min(Math.floor(fy), FILTER_TABLE_SIZE - 1)

    syncNeeded = @filter.xWidth > 0.5 or @filter.yWidth > 0.5
    
    for y in [y0..y1]
      for x in [x0..x1]
        offset = ify[y - y0] * FILTER_TABLE_SIZE + ifx[x - x0]
        filterWeight = @filterTable[offset]
        pixelX = x - @xPixelStart
        pixelY = y - @yPixelStart 
        pixel = if pixel[x][y]? then pixel[x][y] else {} 
        if not syncNeeded 
          pixel.xyz ?= [0, 0, 0]
          [pX, pY, pZ] = pixel.xyz
          pX += filterWeight * sX
          pY += filterWeight * sY
          pZ += filterWeight * sZ
          pixel.xyz = [pX, pY, pZ]
          pixel.weightSum ?= 0
          pixel.weightSum += filterWeight
    
  getSampleExtent: ->
    xStart = Math.floor(@xPixelStart + 0.5 - @filter.xWidth)
    xEnd = Math.floor(@xPixelStart + 0.5 + @xPixelCount + @filter.xWidth)
    yStart = Math.floor(@yPixelStart + 0.5 - @filter.yWidth)
    yEnd = Math.floor(@yPixelStart + 0.5 + @yPixelCount + @filter.yWidth)
    return [xStart, xEnd, yStart, yEnd]
    
  getPixelExtent: ->
    xStart = @xPixelStart
    xEnd = @xPixelStart + @xPixelCount
    yStart = @yPixelStart
    yEnd = @yPixelStart + @yPixelCount
    return [xStart, xEnd, yStart, yEnd]

# ___
# ## Exports:

# The [**`OrthographicCamera`**](#orthographic),
# [**`PerspectiveCamera`**](#perspective) and [**`Film`**](#film)
# classes are added to the global *root* object.
root = exports ? this
root.OrthographicCamera = OrthographicCamera
root.PerspectiveCamera = PerspectiveCamera
root.Film = Film

# If `QUnit` is available, The [**`Camera`**](#camera),
# and [**`ProjectiveCamera`**](#projective) classes are added to
# the global *root* object for testing.
if QUnit?
  root.Camera = Camera
  root.ProjectiveCamera = ProjectiveCamera