# *sceneHandler.coffee* takes the [**JSON**](http://www.json.org/) version of the [**COLLADA**](http://www.collada.org) file uploaded by the user and converts it into usable objects such as [**`Camera`**](camera.html#camera)s, [**`Light`**](light.html#light)s and [**`Shape`**](shape.html#shape)s.
# ___

# ## Requires:
# Functionality in *sceneHandler.coffee* requires access to the following libraries:

# > * [**`_`**](http://underscorejs.org/) - *underscore.js utility library*
_ = require 'underscore'
# > * [**`jsonpath`**](http://goessner.net/articles/JsonPath/) - *XPath-like functionality for [**JSON**](http://www.json.org/)*
jsonpath = require '../../libraries/jsonpath'

# Other classes from other packages are also required:
  
# * From *raytracer/index.html:*
Raytracer = require '../raytracer/'

# > * The [**`Camera`**](camera.html) package and the following classes:
#
# >> * [**`OrthographicCamera`**](camera.html#orthographic)
#
# >> * [**`PerspectiveCamera`**](camera.html#perspective)
#
# >> * [**`Film`**](camera.html#film)
#
Camera = Raytracer.Camera
OrthographicCamera = Raytracer.Camera.OrthographicCamera
PerspectiveCamera = Raytracer.Camera.PerspectiveCamera
Film = Camera.Film

# > * The [**`Geometry`**](geometry.html) package and the following classes:
#
# >> * [**`Vector`**](geometry.html#vector)
#
# >> * [**`Transform`**](transform.html#transform)
#
Geometry = Raytracer.Geometry
Vector = Raytracer.Geometry.Geometry.Vector
Transform = Geometry.Transform.Transform

# ___

# ## Constants:
# Some constants are required for this script:

# > * **`SCENE`** - *Global placeholder for parsed JSON object*
SCENE = {}
# > * **`findInJSON`** - *Renamed `jsonpath.jsonPath` function*
findInJSON = jsonpath.jsonPath

# ___

# ## Functions:

# ### *getValueFrom*:
# > **`getValueFrom`** takes an object from the converted [**JSON**](http://www.json.org/) and finds out the actual value that should be returned. Because we are using the [**xml2json**](http://www.fyneworks.com/jquery/xml-to-json/) plugin in *extended* mode, all XML nodes are converted into `Array`s which allows this conversion code to be based off the [**COLLADA specification document**](documents/collada_spec_1_5.pdf).
#
# > Specifically, **`getValueFrom`** handles what to do when we recieve:
#
# > 1. An `Array` of `Object`s,
#
# > 2. A single `Object` with a `text` property or,
#
# > 3. An `Object` such as a `String` or `Number`
#
#
# > **`getValueFrom`** is used throughout *sceneHandler.coffee*.
getValueFrom = (obj) ->
  if _.isArray obj
    if obj.length is 0
      return null
    if obj.length is 1
      return getValueFrom obj[0]
    if obj.length > 1
      return obj
      
  else if obj.text?
    number = +obj.text
    unless _.isNaN number
      return number
    return obj.text

  else
    number = +obj
    unless _.isNaN number
      return number
    return obj

# ### *parseCOLLADASceneDescriptionJSON*:
# > **`parseCOLLADASceneDescriptionJSON`** takes the whole [**JSON**](http://www.json.org/) string received by the server when the user uploads a [**COLLADA**](http://www.collada.org) file and parses it to an `Object`. It is then responsible for breaking the generation of the **`SCENE`** down into several smaller tasks:
# 
# > 1. Extract [**`Camera`**](camera.html#camera) objects from JSON
#
parseCOLLADASceneDescriptionJSON = (sceneDescriptionJSON) ->
  SCENE = JSON.parse sceneDescriptionJSON
  console.log getCamerasIn SCENE

# ### *getCamerasIn*:
# > **`getCamerasIn`** performs the task of finding all the `<node>` elements who have `<instance_camera>` child elements within the parsed [**COLLADA**](http://www.collada.org) XML document. The [**`JSONPath`**](http://goessner.net/articles/JsonPath/) expression:
#
# >> `$..node[?(@.instance_camera)]`
#
# > searches for all `node` objects with the property `instance_camera`, and returns an `Array` of the results. 
#
# > Each of the results are passed to [**`createCamera`**](#create-camera) to determine the [**`Camera`**](camera.html#camera) type ([**`OrthographicCamera`**](camera.html#orthographic) or [**`PerspectiveCamera`**](camera.html#perspective)) and create the `Object`.
getCamerasIn = (scene) ->
  camera_nodes = findInJSON scene, '$..node[?(@.instance_camera)]'
  sceneCameras = []
  for camera_node in camera_nodes
    sceneCameras.concat createCamera(camera_node)

# ### <section id='create-camera'>*createCamera*:</section>
# > **`createCamera`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract the relevant information needed to create a [**`Camera`**](camera.html#camera) `Object` from an `<instance_camera>` element. The relevant structure is as follows:
createCamera = (camera_node) ->
  cameras = []
  instanceCameras = camera_node.instance_camera
  # > * A `<node>` element may have **0 or more** `<instance_camera>` child elements, so we must iterate over all of them.
  for instanceCamera in instanceCameras
    # > * An `<instance_camera>` element must have an `url` attribute which refers to a unique `id` of a `<camera>` element - searching for that `id` will return exactly one `<camera>` element.
    camera = getValueFrom findInJSON SCENE, "$..camera[?(@.id == '#{instanceCamera.url.substring(1)}')]"
    if camera? and camera isnt false
      camToWorld = createObjectToWorldTransform camera_node
      # > * A `<camera>` element must have exactly **1** `<optics>` child element.
      optics = getValueFrom camera.optics
      if optics? and not _.isArray optics
        # > * An `<optics>` element must have exactly **1** `<technique_common>` child element.
        techniqueCommon = getValueFrom optics.technique_common
        if techniqueCommon? and not _.isArray optics
          # > * An `<optics>` element must have a `<technique_common>` child element with either **1** `<perspective>` child element or **1** `<orthographic>` child element.
          if techniqueCommon.perspective? and techniqueCommon.perspective.length is 1
            cameras.push createPerspectiveCamera(camToWorld, getValueFrom techniqueCommon.perspective)
          else if techniqueCommon.orthographic? and techniqueCommon.orthographic.length is 1
            cameras.push createOrthographicCamera(camToWorld, getValueFrom techniqueCommon.orthographic)
          # > If the structure is correct, a new [**`OrthographicCamera`**](camera.html#orthographic) or [**`PerspectiveCamera`**](camera.html#perspective) is created.
          # > Otherwise the [**COLLADA**](http://www.collada.org) document doesn't meet the [**COLLADA specification**](documents/collada_spec_1_5.pdf), so an `Error` is thrown.
          else throw Error 'Something is wrong with the COLLADA file: an `optics` element must have a `technique_common` child element with either a `perspective` child element or a `orthographic` child element. A Camera was not created.'
        else throw Error 'Something is wrong with the COLLADA file: an `optics` element must have exactly  1 `technique_common` child element.'
      else throw Error 'Something is wrong with the COLLADA file: a `camera` element must have exactly 1 `optics` child element.'
    else throw Error "Something is wrong with the COLLADA file: there is no `camera` element with the `id` '#{instanceCamera.url.substring(1)}'"
    
  # > All created [**`Camera`**](camera.html#camera)s are returned to the `SCENE`.
  return cameras

# ### *createObjectToWorldTransform*:
# > **`createObjectToWorldTransform`** takes a `<node>` element, extracts the *Translation*, *Rotation* and *Scale* transforms using [**`getTranslation`**](#get-translation), [**`getRotation`**](#get-rotation) and [**`getScale`**](#get-scale) and combines them into a single `objectToWorld` [**`Transform`**](transform.html#transform). The relevant structure is as follows:
createObjectToWorldTransform = (node) ->
  objectToWorld = new Transform()
  # > * A `<node>` element may have **0 or more** `<translate>` elements, so we must iterate over any and all of them.
  translates = node.translate
  if translates? and _.isArray translates
    translateTs = (getTranslation(translate) for translate in translates)
    for translateT in translateTs  
      objectToWorld = Transform.Multiply objectToWorld, translateT
  # > * A `<node>` element may have **0 or more** `<rotate>` elements, so we must iterate over any and all of them.
  rotates = node.rotate
  if rotates? and _.isArray rotates
    rotateTs = (getRotation(rotate) for rotate in rotates)
    for rotateT in rotateTs
      objectToWorld = Transform.Multiply objectToWorld, rotateT
  # > * A `<node>` element may have **0 or more** `<scale>` elements, so we must iterate over any and all of them.
  scales = node.scale
  if scales? and _.isArray scales
    scaleTs = (getScale(scale) for scale in scales)
    for scaleT in scaleTs
      objectToWorld = Transform.Multiply objectToWorld, scaleT
  
  return objectToWorld

# ### <section id='get-translation'>*getTranslation*:</section>
# > **`getTranslation`** takes a `<translate>` element and creates a new *Translate* [**`Transform`**](transform.html#transform). A `<translate>` element has the following form:
#
# >> `<translate>X Y Z</translate>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
getTranslation = (translate) ->
  [translateX, translateY, translateZ] = translate.split(' ')
  return Transform.Translate new Vector(+translateX, +translateY, +translateZ)

# ### <section id='get-rotation'>*getRotation*:</section>
# > **`getRotation`** takes a `<rotate>` element and creates a new *Rotate* [**`Transform`**](transform.html#transform). A `<rotate>` element has the following form:
#
# >> `<rotate>X Y Z DEGREES</rotate>`,
#
# > where X, Y and Z are binary flags which indicate which *axis* is being rotated around.
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).  If the `DEGREES` value is exactly divisible by `360`, an identity [**`Transform`**](transform.html#transform) is returned. If none of the `X`, `Y` or `Z` flags are set, an `Error` is thrown.
getRotation = (rotate) ->
  [axisX, axisY, axisZ, degrees] = rotate.split(" ")
  if +degrees % 360 isnt 0
    if +axisX is 1 then return Transform.RotateX(+degrees)
    else if +axisY is 1 then return Transform.RotateY(+degrees)
    else if +axisZ is 1 then return Transform.RotateZ(+degrees)
    else throw Error 'Something is wrong with the COLLADA file: No axis bit is set in `<rotate>`.'
  else return new Transform()

# ### <section id='get-scale'>*getScale*:</section>
# > **`getScale`** takes a `<scale>` element and creates a new *Scale* [**`Transform`**](transform.html#transform). A `<scale>` element has the following form:
#
# >> `<scale>X Y Z</scale>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
getScale = (scale) ->
  [scaleX, scaleY, scaleZ] = scale.split(" ")
  return Transform.Scale +scaleX, +scaleY, +scaleZ

# ### *createPerspectiveCamera*:
# > **`createPerspectiveCamera`** takes a `<technique_common><perspective></technique_common>` element and creates a new [**`PerspectiveCamera`**](camera.html#perspective). A `<perspective>` element must contain:
#
# > * A `<znear>` element and
#
# > * A `<zfar>` element,
#
# > as well as either:
#
# > * A single `<xfov>` element
#
# > * A single `<yfov>` element
#
# > * Both an `<xfov>` and a `<yfov>` element
#
# > * An `<aspect_ratio>` element and either `<xfov>` or `<yfov>`
#
# > If the `aspect_ratio` element is not present, the aspect ratio should be calculated from the `xfov` and `yfov` elements and the current viewport.
#
# > If the structure is correct, a new [**`PerspectiveCamera`**](camera.html#perspective) is created. Otherwise the [**COLLADA**](http://www.collada.org) document doesn't meet the [**COLLADA specification**](documents/collada_spec_1_5.pdf), so an `Error` is thrown.
createPerspectiveCamera = (camToWorld, perspective) ->
  if perspective.znear?
    near = getValueFrom perspective.znear
  else throw Error "Something is wrong with the COLLADA file: a `perspective` element must have exactly 1 `znear` child element."
  if perspective.zfar?
    far = getValueFrom perspective.zfar
  else throw Error "Something is wrong with the COLLADA file: a `perspective` element must have exactly 1 `zfar` child element."
  if perspective.xfov then xfov = getValueFrom perspective.xfov else null
  if perspective.yfov then yfov = getValueFrom perspective.yfov else null
  if perspective.aspect_ratio then aspectRatio = getValueFrom perspective.aspect_ratio else null
  if xfov? and yfov? and not aspectRatio?
    aspectRatio = xfov / yfov
  else if xfov? and aspectRatio? and not yfov?
    yfov = xfov / aspectRatio
  else if yfov? and aspectRatio? and not xfov?
    xfov = yfov * aspectRaio
  else if not xfov? and not yfox?
    throw Error 'Something is wrong with the COLLADA file: a `perspective` element must have either an `xfov` or a `yfov` child element.'
  `// TODO else aspectRatio = getAspectRatio()`
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]  
  return new PerspectiveCamera(camToWorld, xfov, near, far, screenWindow, 0, 0, 0, 0, new Film(200, 200))

# ### *createOrthographicCamera*:
# > **`createOrthographicCamera`** takes a `<technique_common><orthographic></technique_common>` element and creates a new [**`OrthographicCamera`**](camera.html#orthographic). A `<orthographic>` element must contain:
#
# > * A `<znear>` element and
#
# > * A `<zfar>` element,
#
# > as well as either:
#
# > * A single `<xmag>` element
#
# > * A single `<ymag>` element
#
# > * Both an `<xmag>` and a `<ymag>` element
#
# > * An `<aspect_ratio>` element and either `<xmag>` or `<ymag>`
#
# > If the `aspect_ratio` element is not present, the aspect ratio should be calculated from the `xmag` and `ymag` elements and the current viewport.
#
# > If the structure is correct, a new [**`OrthographicCamera`**](camera.html#orthographic) is created. Otherwise the [**COLLADA**](http://www.collada.org) document doesn't meet the [**COLLADA specification**](documents/collada_spec_1_5.pdf), so an `Error` is thrown.
createOrthographicCamera = (camToWorld, orthographic) ->
  if orthographic.znear?
    near = getValueFrom orthographic.znear
  else throw Error "Something is wrong with the COLLADA file: an `orthographic` element must have exactly 1 `znear` child element."
  if orthographic.zfar?
    far = getValueFrom orthographic.zfar
  else throw Error "Something is wrong with the COLLADA file: an `orthographic` element must have exactly 1 `zfar` child element."
  if orthographic.xmag? then xmag = getValueFrom orthographic.xmag else null
  if orthographic.ymag? then ymag = getValueFrom orthographic.ymag else null
  if orthographic.aspect_ratio? then aspectRatio = getValueFrom orthographic.aspect_ratio else null
  if xmag? and ymag? and not aspectRatio?
    aspectRatio = (xmag / 2) / (ymag / 2)
  else if xmag? and aspectRatio? and not ymag?
    ymag = (xmag / 2) / aspectRatio
  else if ymag? and aspectRatio? and not xmag?
    xmag = (ymag / 2) * aspectRaio
  else if not xmag? and not ymag?
    throw Error 'Something is wrong with the COLLADA file: a `orthographic` element must have either an `xmag` or a `ymag` child element.'
  `// TODO else aspectRatio = getAspectRatio()`
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]
  return new OrthographicCamera(camToWorld, near, far, screenWindow, 0, 0, 0, 0, new Film(200, 200))

# ___
# ## Exports:

# The **`parseCOLLADASceneDescriptionJSON`** function is added to the global `root` object.
exports.parse = parseCOLLADASceneDescriptionJSON