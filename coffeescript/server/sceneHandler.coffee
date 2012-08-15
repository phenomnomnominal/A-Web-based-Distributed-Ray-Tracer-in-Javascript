# *sceneHandler.coffee* takes the [**JSON**](http://www.json.org/) version of the [**COLLADA**](http://www.collada.org) file uploaded by the user and converts it into usable objects such as
# [**`Cameras`**](camera.html#camera), [**`Lights`**](light.html#light) and [**`Shapes`**](shape.html#shape).
# ___

# ## Requires:
# Functionality in *sceneHandler.coffee* requires access to the following libraries:

# > [**`_`**](http://underscorejs.org/) - underscore.js utility library
_ = require 'underscore'
# > [**`jsonpath`**](http://goessner.net/articles/JsonPath/) - XPath-like functionality for [**JSON**](http://www.json.org/)
jsonpath = require '../../libraries/jsonpath'

# > **`raytracer`** - Classes from *coffeescript/raytracer/*:
#
# > * [**`OrthographicCamera`**](camera.html#orthographic)
#
# > * [**`PerspectiveCamera`**](camera.html#perspective)
#
# > * [**`Film`**](camera.html#film)
#
# > * [**`AnimatedTransform`**](animatedTransform.html#animT)
#
# > * [**`Vector`**](geometry.html#vector)
#
# > * [**`Transform`**](transform.html#transform)
#
# > * [**`TriangleMesh`**](triangle.html#mesh)
raytracer = require('../raytracer/').Raytracer

OrthographicCamera = raytracer.OrthographicCamera
PerspectiveCamera = raytracer.PerspectiveCamera
Film = raytracer.Film

AnimatedTransform = raytracer.AnimatedTransform
Transform = raytracer.Transform
Vector = raytracer.Vector
Point = raytracer.Point
Normal = raytracer.Normal

TriangleMesh = raytracer.TriangleMesh

DistantLight = raytracer.DistantLight
PointLight = raytracer.PointLight
SpotLight = raytracer.SpotLight

RGBSpectrum = raytracer.RGBSpectrum

KdTree = raytracer.KdTree

Scene = raytracer.Scene

# ___

# ## COLLADA Values:
# It is useful to have references to groupings of some common [**COLLADA**](http://www.collada.org) values:

# * `inputSemantic` - Valid `<input>` semantic attribute values
inputSemantic = ['BINORMAL', 'COLOR', 'CONTINUITY', 'IMAGE', 'INPUT',
                 'IN_TANGENT', 'INTERPOLATION', 'INV_BIND_MATRIX', 'JOINT',
                 'LINEAR_STEPS', 'MORPH_TARGET', 'MORPH_WEIGHT', 'NORMAL', 
                 'OUTPUT', 'OUT_TANGENT', 'POSITION', 'TANGENT', 'TEXBINORMAL',
                 'TEXCOORD', 'TEXTANGENT', 'UV', 'VERTEX', 'WEIGHT']

# ___

# ## Error Types:
# Some specific **`Error`** types for this script:

# <section id='cfe'></section>
#
# * **`COLLADAFileError`**:
#
# >> These errors are thrown when something is wrong with the supplied [**COLLADA**](http://www.collada.org) file
class COLLADAFileError extends Error
# <section id='ude'></section>
#
# * **`UnsupportedDataError`**:
#
# >> These errors are thrown when valid [**COLLADA**](http://www.collada.org) data is received but we don't know how handle it
class UnsupportedDataError extends Error

# ___

# ## Utility Functions:

# ### *parseCOLLADASceneDescriptionJSON*:
# > **`parseCOLLADASceneDescriptionJSON`** is the main function of *sceneHandler.coffee*. It takes the whole [**JSON**](http://www.json.org/) string received when the user uploads a [**COLLADA**](http://www.collada.org) file and parses it to an `Object`. 
#
# > It is then responsible for breaking the generation of the `render` down into several smaller tasks:
# 
# > 1. Extract [**`Cameras`**](camera.html) from `scene`
#
# > 2. Extract [**`Shapes`**](shape.html) from `scene`
parseCOLLADASceneDescriptionJSON = (sceneDescriptionJSON) ->
  sceneObj = JSON.parse sceneDescriptionJSON
  scene = makeScene _.flatten(getShapesFrom sceneObj), _.flatten(getLightsFrom sceneObj)
  render = 
    cameras: _.flatten getCamerasFrom sceneObj
    scene: scene

makeScene = (geometry, lights) ->
  #if geometry.length is 0
  #  throw COLLADAFileError 'no geometry to render.'
  #if lights.length is 0
  #  throw COLLADAFileError 'no lights, image will be black.'
  #accelerator = new KdTree(geometry)
  #return new Scene(accelerator, lights)
  return { geometry: geometry, lights: lights }

# ### *getValueOf*:
# > **`getValueOf`** takes an object and decides the best value that should be returned. It is useful when selecting data from the converted [**JSON**](http://www.json.org/), where we often find an array with a single item, or a stringified **`Number`**.
#
# > Specifically, **`getValueOf`** handles what to do when we receive:
#
# > 1. Any `Array` of `Object`s,
#
# > 2. Any `Object` with a `text` property or,
#
# > 3. Any native `Object` such as a `String` or `Number`
getValueOf = (obj) ->
  if obj?
    if _.isArray obj
      if obj.length is 0
        return null
      if obj.length is 1
        return getValueOf obj[0]
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
  return undefined
    
# ### *getObjectsFrom*:
# > **`getObjectsFrom`** returns all objects within the `root` object which match the [**JSONPath**](http://goessner.net/articles/JsonPath/) `path`.
getObjectsFrom = (root, path) ->
  return getValueOf jsonpath.jsonPath root, path


# ### *atLeastOnePropertyIn*:
# > **`atLeastOnePropertyIn`** returns a `Boolean` for whether `obj` has a property with a name from the `properties` list.
atLeastOnePropertyIn = (obj, properties)->
  return _.any properties, ((property) -> return obj[property]?)

# ___

# ## Transform Handling:    

# ### *createObjectToWorldTransform*:
# > **`createObjectToWorldTransform`** takes a `<node>` element, extracts the *Translation*, *Rotation* and *Scale* transforms using [**`getTranslation`**](#get-translation), [**`getRotation`**](#get-rotation) and [**`getScale`**](#get-scale) and combines them into a single `objectToWorld` [**`Transform`**](transform.html#transform).
#
# > **The relevant structure is as follows:**
#
# > * A `<node>` element may contain:
#
# >> * **0 or more** `<translate>` elements
#
# >> * **0 or more** `<rotate>` elements
#
# >> * **0 or more** `<scale>` elements
createObjectToWorldTransform = (node) ->
  objectToWorld = new Transform()
  
  translates = node.translate
  if translates? and _.isArray translates
    translateTs = (getTranslation(translate) for translate in translates)
    for translateT in translateTs  
      objectToWorld = Transform.Multiply objectToWorld, translateT
  
  rotates = node.rotate
  if rotates? and _.isArray rotates
    rotateTs = (getRotation(rotate) for rotate in rotates)
    for rotateT in rotateTs
      objectToWorld = Transform.Multiply objectToWorld, rotateT
  
  scales = node.scale
  if scales? and _.isArray scales
    scaleTs = (getScale(scale) for scale in scales)
    for scaleT in scaleTs
      objectToWorld = Transform.Multiply objectToWorld, scaleT

  return objectToWorld

# ### <section id='get-translation'>*getTranslation*:</section>
# > **`getTranslation`** takes a `<translate>` element and creates a new *Translate* [**`Transform`**](transform.html#transform). A `<translate>` element must have the following form:
#
# >> `<translate>X Y Z</translate>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
getTranslation = (translate) ->
  [translateX, translateY, translateZ] = translate.split ' '
  
  unless translateX? and translateY? and translateZ?
    throw COLLADAFileError 'A `<translate>` must have X, Y and Z components.'
  unless _.all [+translateX, +translateY, +translateZ], _.isNumber
    throw COLLADAFileError 'The X, Y and Z components of a `<translate>` must be numbers.'
    
  return Transform.Translate new Vector(+translateX, +translateY, +translateZ)

# ### <section id='get-rotation'>*getRotation*:</section>
# > **`getRotation`** takes a `<rotate>` element and creates a new *Rotate* [**`Transform`**](transform.html#transform). A `<rotate>` element must have the following form:
#
# >> `<rotate>X Y Z DEGREES</rotate>`
#
# > where X, Y and Z are binary flags which indicate which axis is being rotated around.
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).  
getRotation = (rotate) ->
  [axisX, axisY, axisZ, degrees] = rotate.split ' '
  
  unless axisX? and axisY? and axisZ? and degrees?
    throw COLLADAFileError 'A `<rotate>` must have X, Y, Z and DEGREES components.'
  unless _.all [+axisX, +axisY, +axisZ, +degrees], _.isNumber
    throw COLLADAFileError 'The X, Y, Z and DEGREES components of a `<rotate>` must be numbers.'
  
  if +degrees % 360 isnt 0
    if +axisX is 1 
      return Transform.RotateX +degrees
    else if +axisY is 1 
      return Transform.RotateY +degrees
    else if +axisZ is 1 
      return Transform.RotateZ +degrees
    else
      throw COLLADAFileError 'No axis bit is set in `<rotate>`.'
      
  return new Transform()

# ### <section id='get-scale'>*getScale*:</section>
# > **`getScale`** takes a `<scale>` element and creates a new *Scale* [**`Transform`**](transform.html#transform). A `<scale>` element must have the following form:
#
# >> `<scale>X Y Z</scale>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
getScale = (scale) ->
  [scaleX, scaleY, scaleZ] = scale.split ' '
  
  unless scaleX? and scaleY? and scaleZ?
    throw COLLADAFileError 'A `<scale>` must have X, Y and Z components.'
  unless _.all [+scaleX, +scaleY, +scaleZ], _.isNumber
    throw COLLADAFileError 'The X, Y and Z components of a `<scale>` must be numbers.'
  
  return Transform.Scale +scaleX, +scaleY, +scaleZ

# ___

# ## Camera Handling:
# > We are able to handle two different [**`Camera`**](camera.html) types:
#
# > 1. [**`OrthographicCamera`**](camera.html#orthographic)
#
# > 2. [**`PerspectiveCamera`**](camera.html#perspective)

# ### *getCamerasFrom*:
# > **`getCamerasFrom`** performs the task of finding all the `<node>` elements who have `<instance_camera>` child elements within the parsed [**COLLADA**](http://www.collada.org) XML document. The [**JSONPath**](http://goessner.net/articles/JsonPath/) expression:
#
# >> `$..node[?(@.instance_camera)]`
#
# > searches for all `node` objects with the property `instance_camera`.
#
# > Each of the results is passed to [**`createCamera`**](#create-camera) to determine the [**`Camera`**](camera.html#camera) type and create it.
getCamerasFrom = (scene) ->
  camera_nodes = getObjectsFrom scene, '$..node[?(@.instance_camera)]'
  if camera_nodes isnt false
    if _.isArray camera_nodes
      return (createCamera(camera_node, scene) for camera_node in camera_nodes)
    return [createCamera(camera_nodes, scene)]
  return []

# ### <section id='create-camera'>*createCamera*:</section>
# > **`createCamera`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract the relevant information needed to create a [**`Camera`**](camera.html#camera) from an `<instance_camera>` element. 
#
# > **The relevant structure is as follows:**
createCamera = (camera_node, scene) ->
  cameras = []
  camToWorld = createObjectToWorldTransform camera_node

  # > * A `<node>` element may contain **0 or more** `<instance_camera>` elements
  instanceCameras = camera_node.instance_camera
  for instanceCamera in (instanceCameras ? [])
    
    # > * An `<instance_camera>` element must have a `url` attribute which refers to the `id` of a unique `<camera>` element
    id = if instanceCamera.url.substr(0, 1) is '#' then instanceCamera.url.substring(1) else instanceCamera.url
    camera = getObjectsFrom scene, "$..camera[?(@.id == '#{id}')]"
    if camera is false
      throw COLLADAFileError "There is no `<camera>` with the `id` '#{id}'"
      
    # > * A `<camera>` element must contain **1** `<optics>` element
    optics = getValueOf camera.optics
    unless optics? and not _.isArray optics 
      throw COLLADAFileError 'A `<camera>` must contain 1 `<optics>`.'
    
    # > * An `<optics>` element must contain **1** `<technique_common>` element which contains either **1** `<perspective>` element or **1** `<orthographic>` element
    techniqueCommon = getValueOf optics.technique_common
    unless techniqueCommon? and not _.isArray optics
      throw COLLADAFileError 'An `<optics>` must contain 1 `<technique_common>`.'
    unless techniqueCommon.perspective? or techniqueCommon.orthographic?
      throw COLLADAFileError 'An `<optics><technique_common>` must contain either 1 `<perspective>` or 1 `<orthographic>`.'

    # > If a `<perspective>` element is present a [**`PerspectiveCamera`**](camera.html#perspective) is created.
    perspective = getValueOf techniqueCommon.perspective
    if perspective?
      if _.isArray perspective
        throw COLLADAFileError 'An `<optics><technique_common>` may contain at most 1 `<perspective>`'
      cameras.push createPerspectiveCamera(camToWorld, perspective)  

    # > If a `<orthographic>` element is present an [**`OrthographicCamera`**](camera.html#orthographic) is created.
    orthographic = getValueOf techniqueCommon.orthographic
    if orthographic? 
      if _.isArray orthographic
        throw COLLADAFileError 'An `<optics><technique_common>` may contain at most 1 `<orthographic>`'
      cameras.push createOrthographicCamera(camToWorld, orthographic)
        
  return cameras

# ### *createPerspectiveCamera*:
# > **`createPerspectiveCamera`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract the relevant information needed to create a [**`PerspectiveCamera`**](camera.html#perspective) from an `<perspective>` element.
#
# > **The relevant structure is as follows:**
#
# > * A `<perspective>` element must contain:
createPerspectiveCamera = (camToWorld, perspective) ->
  camToWorld = new AnimatedTransform(camToWorld, 0, camToWorld, 0)
  
  # >> * **1** `<znear>` element
  near = getValueOf perspective.znear
  unless near? and not _.isArray near
    throw COLLADAFileError 'A `<perspective>` element must contain 1 `<znear>`.'
  
  # >> * **1** `<zfar>` element
  far = getValueOf perspective.zfar
  unless far? and not _.isArray far
    throw COLLADAFileError 'A `<perspective>` element must contain 1 `<zfar>`.'
   
  # > * As well as either:

  # >> * **1** `<xfov>` element
  #
  # >> * **1** `<yfov>` element
  #
  # >> * **1** `<xfov>` and **1** `<yfov>` element
  #
  # >> * **1** `<aspect_ratio>` element and either **1** `<xfov>` or **1** `<yfov>`
  if perspective.xfov? then xfov = getValueOf perspective.xfov else null
  if perspective.yfov? then yfov = getValueOf perspective.yfov else null  
  if perspective.aspect_ratio? then aspectRatio = getValueOf perspective.aspect_ratio else null
  
  # > These are used to determine any missing values.
  if xfov? and yfov? and not aspectRatio?
    aspectRatio = xfov / yfov
  else if xfov? and aspectRatio? and not yfov?
    yfov = xfov / aspectRatio
  else if yfov? and aspectRatio? and not xfov?
    xfov = yfov * aspectRatio
  # > If the `<aspect_ratio>` element is not present, the `<aspectRatio>` should be calculated from the `<xfov>` and `<yfov>` elements and the current viewport.  
  else if not xfov? and not yfov?
    throw COLLADAFileError 'A `<perspective>` must contain either 1 `<xfov>` or 1 `<yfov>`.'
  `// TODO else aspectRatio = getAspectRatio()`
  `// TEMPORARY FIX`
  unless aspectRatio?
    aspectRatio = 1
  
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]
    
  # > This data is used to create a new [**`PerspectiveCamera`**](camera.html#perspective)
  return new PerspectiveCamera(camToWorld, 0, 0, new Film(200, 200), xfov, near, far, screenWindow, 0, 0)

# ### *createOrthographicCamera*:
# > **`createOrthographicCamera`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract the relevant information needed to create an [**`OrthographicCamera`**](camera.html#orthographic) from an `<orthographic>` element.
#
# > **The relevant structure is as follows:**
#
# > * An `<orthographic>` element must contain:
createOrthographicCamera = (camToWorld, orthographic) ->
  camToWorld = new AnimatedTransform(camToWorld, 0, camToWorld, 0)
  
  # >> * **1** `<znear>` element
  near = getValueOf orthographic.znear
  unless near? and not _.isArray near
    throw COLLADAFileError 'An `<orthographic>` element must contain 1 `<znear>`.'

  # >> * **1** `<zfar>` element      
  far = getValueOf orthographic.zfar
  unless far? and not _.isArray far
    throw COLLADAFileError 'An `<orthographic>` element must contain 1 `<zfar>`.'
   
  # > * As well as either:
  
  # >> * **1** `<xmag>` element
  #
  # >> * **1** `<ymag>` element
  #
  # >> * **1** `<xmag>` and **1** `<ymag>` element
  #
  # >> * **1** `<aspect_ratio>` element and either **1** `<xmag>` or **1** `<ymag>`  
  if orthographic.xmag? then xmag = getValueOf orthographic.xmag
  if orthographic.ymag? then ymag = getValueOf orthographic.ymag  
  if orthographic.aspect_ratio? then aspectRatio = getValueOf orthographic.aspect_ratio
  
  # > These are used to determine any missing values.
  if xmag? and ymag? and not aspectRatio?
    aspectRatio = (xmag / 2) / (ymag / 2)
  else if xmag? and aspectRatio? and not ymag?
    ymag = (xmag / 2) / aspectRatio
  else if ymag? and aspectRatio? and not xmag?
    xmag = (ymag / 2) * aspectRaio
  # > If the `<aspect_ratio>` element is not present, the `<aspectRatio>` should be calculated from the `<xmag>` and `<ymag>` elements and the current viewport.
  else if not xmag? and not ymag?
    throw  COLLADAFileError 'An `<orthographic>` must have either 1 `<xmag>` or 1 `<ymag>`.'
  `// TODO else aspectRatio = getAspectRatio()`
  `// TEMPORARY FIX`
  unless aspectRatio
    aspectRatio = 1
  
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]
    
  # > This data is used to create a new [**`OrthographicCamera`**](camera.html#orthographic)
  return new OrthographicCamera(camToWorld, 0, 0, new Film(200, 200), near, far, screenWindow, 0, 0)

# ___

# ## Geometry Handling:
# > All [**COLLADA**](http://www.collada.org) geometry elements need to be converted to [**`TriangleMesh`**](triangle.html#mesh)es.
# 
# > Currently supported [**COLLADA**](http://www.collada.org) geometry types:
#
# > * `<polylist>`

# ### *getShapesFrom*:
# > **`getShapesFrom`** performs the task of finding all the `<node>` elements who have `<instance_geometry>` child elements within the parsed [**COLLADA**](http://www.collada.org) XML document. The [**JSONPath**](http://goessner.net/articles/JsonPath/) expression:
#
# >> `$..node[?(@.instance_geometry)]`
#
# > searches for all `node` objects with the property `instance_geometry`. 
#
# > Each of the results is passed to [**`createShapes`**](#create-shapes) to determine the [**`Shape`**](shape.html#shape) type and create it.
getShapesFrom = (scene) ->
  geometry_nodes = getObjectsFrom scene, '$..node[?(@.instance_geometry)]'
  if geometry_nodes isnt false
    if _.isArray geometry_nodes
      return (createShapes(geometry_node, scene) for geometry_node in geometry_nodes)
    return [createShapes geometry_nodes, scene]
  return []
    
# ### <section id='create-shapes'>*createShapes*:</section>
# > **`createShapes`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract the relevant information needed to create a [**`Shape`**](shape.html) from an `<instance_geometry>` element.
#
# > **The relevant structure is as follows:**
createShapes = (geometry_node, scene) ->
  shapes = []
  shapeToWorld = createObjectToWorldTransform geometry_node

  # > * A `<node>` element may contain **0 or more** `<instance_geometry>` elements
  instanceGeometries = geometry_node.instance_geometry
  for instanceGeometry in (instanceGeometries ? [])
    
    bindMaterial = getValueOf instanceGeometry.bind_material
    if bindMaterial?
      material = getMaterialFrom bindMaterial

    # > * An `<instance_geometry>` element must have a `url` attribute which refers to the `id` of a  unique `<geometry>` element
    id = if instanceGeometry.url.substr(0, 1) is '#' then instanceGeometry.url.substring(1) else instanceGeometry.url    
    geometry = getObjectsFrom scene, "$..geometry[?(@.id == '#{id}')]"
    if geometry is false
      throw COLLADAFileError "There is no `<geometry>` with the `id` '#{id}'"
      
    # > * A `<geometry>` element must contain **1** element from the following *geometric_element* types:
    # >> * `<convex_mesh>`
    # >> * `<mesh>`
    # >> * `<spline>`
    # >> * `<brep>`
    geometric_elements = ['convex_mesh', 'mesh', 'spline', 'brep']
    unless atLeastOnePropertyIn geometry, geometric_elements
      throw COLLADAFileError '`<geometry>` must have 1 of either `<convex_mesh>`, `<mesh>`, `<spline>` or `<brep>`.'
    
    if geometry.mesh?
      mesh = getValueOf geometry.mesh
      
      # >> * A `<mesh>` element must contain **1** `<vertices>` element
      vertices = getVerticesFrom mesh
      
      # >> * A `<mesh>` element may contain **0 or more** of the *primitive_element* types:
      # >>> * `<lines>`
      # >>> * `<linestrips>`
      # >>> * `<polygons>`
      # >>> * `<polylist>`
      # >>> * `<triangles>`
      # >>> * `<trifans>`
      # >>> * `<tristrips>`
      primitiveElements = ['lines', 'linestrips', 'polygons', 'polylist', 'triangles', 'trifans', 'tristrips']
      unless atLeastOnePropertyIn mesh, primitiveElements
        throw COLLADAFileError '`<mesh>` may contain 0 or more `<lines>`, `<linestrips>`, `<polygons>`, `<polylist>`, `<triangles>`, `<trifans>` or `<tristrips>`.'
      
      # > [**`TriangleMeshes`**](triangle.html#mesh) are created from the *primitive_elements*.
      if mesh.polygons?
        `// TODO: Handle <polygons> elements`
        console.warn 'Can\'t handle `<polygons>` yet'
        
      if mesh.polylist?
        polylists = getPolylistsFrom mesh
        triangleMesh = createTriangleMesh(shapeToWorld, vertices, polylists, 'POLYLIST')
        shapes.push triangleMesh
      
      if mesh.triangles?
        `// TODO: Handle <triangles> elements`
        console.warn 'Can\'t handle `<triangles>` yet'
      
      if mesh.tristrips?
        `// TODO: Handle <tristrips> elements`
        console.warn 'Can\'t handle `<tristrips>` yet'
      
  return shapes
  
getMaterialFrom = (bindMaterial, scene) ->
  techniqueCommon = getValueOf bindMaterial.technique_common
  unless techniqueCommon? and not _.isArray techniqueCommon
    throw COLLADAFileError 'A `<bind_material>` must contain 1 `<techniqueCommon>`.'
    
  instanceMaterial = getValueOf techniqueCommon.instance_material
  unless instanceMaterial? and not _.isArray instanceMaterial
    throw COLLADAFileError 'A `<bind_material><technique_common>` must contain 1 `<instance_material>`.'
  
  symbol = getValueOf instanceMaterial.symbol
  unless symbol? and _.isString symbol
    throw COLLADAFileError 'An `<instance_material>` must have a `symbol` attribute.'
  
  target = getValueOf instanceMaterial.target
  unless target? and _.isString target
    throw COLLADAFileError 'An `<instance_material>` must have a `target` attribute.'
    
  id = if target.substr(0, 1) is '#' then target.substring 1 else target
  
  materialElement = getObjectsFrom scene, "$..material[?(@.id == '#{id}')]"
  
  instanceEffect = getVaueOf materialElement.instance_effect
  unless instanceEffect? and not _.isArray instanceEffect
    throw COLLADAFileError 'A `<material>` must contain 1 `<instance_effect>`.'
  
  url = getValueOf instanceEffect.url
  unless url? and _.isString url
    throw COLLADAFileError 'An `<instance_effect>` must have a `url` attribute.'
    
  id = if url.substring(0, 1) is '#' then url.substring 1 else url
  
  effectElement = getObjectsFrom scene, "$..effect[?(@.id == '#{id}')]"
  if effectElement is false
    throw COLLADAFileError "There is no `<effect>` with the `id` '#{id}'"
  
  profileElements = ['profile_BRIDGE', 'profile_CG', 'profile_COMMON', 'profile_GLES', 'profile_GLES2', 'profile_GLSL']
  unless atLeastOnePropertyIn effectElement, profileElements
    throw COLLADAFileError '`<effectElement>` must contain 1 or more `<profile_BRIDGE>`, `<profile_CG>`, `<profile_COMMON>`, `<profile_GLES>`, `<profile_GLES2>` or `<profile_GLSL>`.'
    
  if effectElement.profile_BRIDGE?
    `// TODO: Handle <profile_BRIDGE> elements`
    console.warn 'Can\'t handle `<effect><profile_BRIDGE>` yet'
    
  if effectElement.profile_CG?
    `// TODO: Handle <profile_CG> elements`
    console.warn 'Can\'t handle `<effect><profile_CG>` yet'
    
  if effectElement.profile_COMMON
    profileCommon = getValueOf effectElement.profile_COMMON
    unless _.isArray profileCommon
      profileCommon = [profileCommon]
    for common in profileCommon
      technique = getValueOf common.technique
      unless technique? and not _.isArray technique
        throw COLLADAFileError 'A `<profile_COMMON>` must contain 1 `<technique>`.'
        unless technique.blinn? ^ technique.constant? ^ technique.lambert? ^ technique.phong?
          throw COLLADAFileError 'An `<profile_COMMON><technique>` must contain either 1 `<blinn>` or 1 `<constant>` or 1 `<lambert>` or 1 `<phong>`.'
        
        if technique.blinn?
          `// TODO: Handle <blinn> elements`
          console.warn 'Can\'t handle `<technique><blinn>` yet'
          
        if technique.constant?
          `// TODO: Handle <constant> elements`
          console.warn 'Can\'t handle `<technique><constant>` yet'

        if technique.lambert?
          `// TODO: Handle <lambert> elements`
          console.warn 'Can\'t handle `<technique><lambert>` yet'
          
        if technique.phong?
          `// TODO: Handle <phong> elements`
          console.warn 'Can\'t handle `<technique><phong>` yet'

  if effectElement.profile_GLES?
    `// TODO: Handle <profile_GLES> elements`
    console.warn 'Can\'t handle `<effect><profile_GLES>` yet'

  if effectElement.profile_GLES2?
    `// TODO: Handle <profile_GLES2> elements`
    console.warn 'Can\'t handle `<effect><profile_GLES2>` yet'

  if effectElement.profile_GLSL?
    `// TODO: Handle <profile_GLSL> elements`
    console.warn 'Can\'t handle `<effect><profile_GLSL>` yet'

  
# ### *getVerticesFrom*:
# > **`getVerticesFrom`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract and reorganise the *vertices* data into a more useable format for building [**`TriangleMeshes`**](triangle.html#mesh).
#
# > **The relevant structure is as follows:**
getVerticesFrom = (mesh) ->
  positionSemanticCount = 0
  inputs = []
  
  # > * A `<mesh>` element must contain **1** `<vertices>` element
  vertices = getValueOf mesh.vertices
  unless vertices? and not _.isArray vertices
    throw COLLADAFileError 'A `<mesh>` must contain 1 `<vertices>`.'
  
  # > * A `<vertices>` element must contain **1 or more** `<input> (unshared)` element which refer to a `<source>` element somewhere else in the [**COLLADA**](http://www.collada.org) document.
  verticesInputs = vertices.input
  unless verticesInputs?
    throw COLLADAFileError 'A `<vertices>` must contain 1 or more `<input> (unshared)`.'
    
  # > * **1** of the `<input> (unshared)` elements must have `semantic` set to `'POSITION'`
  positionSemanticCount++ for input in verticesInputs when input.semantic is 'POSITION'
  unless positionSemanticCount is 1
    throw COLLADAFileError 'A `<vertices>` must contain 1 `<input>` with semantic="POSITION"'
    
  # > * A `<input> (unshared)` element must have:
  for vertexInput in verticesInputs
    
    # >> * a `semantic` attribute, which specifies the type of data in the `<source>` element
    semantic = getValueOf vertexInput.semantic
    unless semantic? and _.isString semantic
      throw COLLADAFileError 'An `<input> (unshared)` must have a `semantic` attribute.'
    
    # >> * a `source` attribute, which specifies the `id` of the `<source>` element 
    source = getValueOf vertexInput.source
    unless source? and _.isString source
      throw COLLADAFileError 'An `<input> (unshared)` must have a `source` attribute.'

    id = if source.substr(0, 1) is '#' then source.substring(1) else source
    sourceElement = getObjectsFrom mesh, "$..source[?(@.id == '#{id}')]"

    if sourceElement is false
      throw COLLADAFileError "There is no `<source>` with the `id` '#{id}'"
    
    # > An `input` containing the `semantic` and the `<source>` element is created for each `<input> (unshared)`.
    input =
      semantic: semantic
      sourceElement: sourceElement
    
    inputs.push input
            
    
  # > An `Object` containing a list of these `input` objects is returned from the function.
  return [input: inputs]
  
# ### *getPolylistsFrom*:
# > **`getPolylistsFrom`** uses the well-defined structure of the [**COLLADA SCHEMA**](http://www.collada.org/2005/COLLADASchema.xsd) to extract and reorganise the *polylist* data into a more useable format for building [**`TriangleMeshes`**](triangle.html#mesh).
#
# > **The relevant structure is as follows:**
getPolylistsFrom = (mesh) ->
  polylists = []
  
  # > * A `<mesh>` element may contain **0 or more** `<polylist>` elements
  for polylist in mesh.polylist

    vertexSemantic = 0
    inputs = []

    # > * A `<polylist>` element may contain **0 or more** `<input> (shared)` elements which refer to a `<source>` element somewhere else in the [**COLLADA**](http://www.collada.org) document.
    polylistInputs = polylist.input
    if polylistInputs?
      
      # > * Any `<input> (shared)` elements must have:
      for polylistInput in polylistInputs
        
        # >> * A `semantic` attribute, which specifies the type of data in the `<source>` element
        semantic = getValueOf polylistInput.semantic
        unless semantic? and _.isString semantic
          throw COLLADAFileError 'An `<input> (shared)` must have a `semantic` attribute.'
        unless semantic in inputSemantic
          throw COLLADAFileError 'An `<input>` must have a valid `semantic` attribute type.'
          
        # >> * A `source` attribute, which specifies the `id` of the `<source>` element 
        source = getValueOf polylistInput.source
        unless source? and _.isString source
          throw COLLADAFileError 'An `<input> (shared)` must have a `source` attribute.'
        
        id = if source.substr(0, 1) is '#' then source.substring(1) else source
          
        # >> * An `offset` attribute, which specifies the offset into the list of values from the `<source>` element
        offset = getValueOf polylistInput.offset
        unless offset? and _.isNumber offset
          throw COLLADAFileError 'An `<input> (shared)` must have an `offset` attribute.'
        
        # > * If there are more than **0** `<input> (shared)` elements, **1** of them must have `semantic` set to 'VERTEX'
        if semantic is 'VERTEX'
          vertexSemantic++
        else
          sourceElement = getObjectsFrom mesh, "$..source[?(@.id == '#{id}')]"
          
        if sourceElement? and sourceElement is false
          throw COLLADAFileError "There is no `<source>` with the `id` '#{id}'"
        
        # > An `input` containing the `semantic`, `source` id, the `<source>` element, and the `offset` is created for each `<input> (shared)`.
        input = 
          semantic: semantic, 
          source: id,
          sourceElement: sourceElement,
          offset: getValueOf polylistInput.offset
        inputs.push input
      
      # > * A `<polylist>` element must have a `count` attribute, which specifies the number of polygon primitives
      count = getValueOf polylist.count
      unless count? and _.isNumber count
        throw COLLADAFileError 'A `<polylist> must have a `count` attribute.'      
      
      # > * A `<polylist>` element may also contain:
      #
      # >> * A `<vcount>` element, which specifies the number of vertices per polygon
      vcount = getValueOf polylist.vcount
      if vcount?
        unless _.isString vcount
          throw COLLADAFileError 'A `<polylist>` may only contain 0 or 1 `<vcount>`.'
        vcount = (+v for v in (getValueOf polylist.vcount).split(' '))
        
      # >> * A `<p>` element, which specifies the vertex attribute indices for all polygons
      p = getValueOf polylist.p
      if p?
        unless _.isString p
          throw COLLADAFileError 'A `<polylist>` may only contain 0 or 1 `<p>`.'
        p = (+p for p in (getValueOf polylist.p).split(' '))
      
    unless vertexSemantic is 1 and polylistInputs?
      throw COLLADAFileError 'If a `<polylist>` has `<input>` children, 1 of them must have semantic="VERTEX"'
      
    # > An object containing the `count`, `inputs`, `vcount` and `p` for each `<polylist>` is pushed into the `polylists` array.
    polylists.push count: count, input: inputs, vcount: vcount, p: p
  
  # > The `polylists` array is returned from the function.
  return polylists

# ### *createTriangleMesh*:
# > **`createTriangleMesh`** takes the organised `<input>` data, creates their `<source>` objects and creates [**`TriangleMesh`**](triangle.html#mesh)es from these objects.
#
# > There are some subtleties to the way that the [**COLLADA**](http://www.collada.org) document organises mesh data. In general, the combination of the `offset` attributes for each `<input>`, the list of indices in the `<p>` or `<v>` elements and the number of vertices per polygon face (either implicit or from `<vcount>`) indicate which `<source>` values belong together.
#
createTriangleMesh = (objectToWorld, vertices, primitive, primitiveType) ->
  verticesSourceObjects = createSourceObjects(vertices)
  primitiveSourceObjects = createSourceObjects(primitive)
  
  sharedInputs = getObjectsFrom primitive, "$..input"
  unless _.isArray sharedInputs
    sharedInputs = [sharedInputs]
  
  # > The `<input>` elements are sorted into the `dataflow` object by their `offset` value, indicating the order in which they should be accessed. 
  dataflow = []
  for input in sharedInputs
    offset = input.offset
    dataflow[offset] = dataflow[offset] ? []

    # > If the `semantic` value is `'VERTEX'` then the data to be accessed comes from the `<vertices>` element, otherwise it comes from the *primitive_element* types.
    switch input.semantic
      when 'VERTEX'
        dataflow[offset].semantic = 'VERTEX'
        for own key, val of verticesSourceObjects
          dataflow[offset].push val
      else
        dataflow[offset].push primitiveSourceObjects[input.semantic]

  # > Faces are created from their natural vertex counts e.g.
  #
  # > * `<polygons>` or `<polylist>` faces can have any number of vertices
  #
  # > * `<triangles>` or `<tristripes>` faces have `3` vertices
  #
  # > This is achieved by walking through the list of indices in the *primitive_element* (e.g. `<p>` for `<polylist>`) and putting the correct source object into the `face` objects. 
  #
  # > The number of objects to put into each `face` is determined by the number of vertices that the face has. This is either determined implicitly from the *primitive_element* or read from the `<vcount>` element.
  faces = []
  switch primitiveType
    when 'POLYLIST'
      pIndex = 0
      for polylist in primitive
        vCount = getObjectsFrom polylist, "$..vcount"
        if vCount isnt false
          p = getObjectsFrom polylist, "$..p"
          if p isnt false
            for v in vCount
              if v > 4
                console.warn 'Polygons with more than 4 vertices will be ignored'
            for v in vCount
              face = vertexCount: v
              for n in [0...v]
                for offset in [0...dataflow.length]
                  for source in dataflow[offset]
                    semantic = source.semantic
                    face[semantic] = face[semantic] ? []
                    face[semantic].push source[p[pIndex]]
                  pIndex++
              faces.push face

  # > Triangles are then created from the faces.
  #
  # > * Faces which only have `3` vertices are already triangles
  #
  # > * Faces with `4` vertices are split into `2` triangles each
  triangles = []
  for face in faces
    if face.vertexCount is 3
      triangles.push face
    if face.vertexCount is 4
      triangle1 = {}
      triangle2 = {}
      for own key, val of face
        if _.isArray val
          triangle1[key] = [val[0], val[1], val[2]]
          triangle2[key] = [val[2], val[3], val[0]]
      triangles.push triangle1, triangle2
  
  # > The data from the triangles is then used to build the arrays which are passed into the [**`TriangleMesh`**](triangle.html#mesh) constructor.
  #
  # > For now, we are only interested in `'POSITION'`, `'NORMAL'` and `'TEXCOORD'` data.
  numberTriangles = 0
  vertexIndices = []
  positions = []
  normals = []
  uvs = []
  for triangle in triangles
    n = 3 * numberTriangles
    vertexIndices.push n, n+1, n+ 2
    for own key, val of triangle
      switch key
        when 'POSITION'
          for position in val
            positions.push position
        when 'NORMAL'
          for normal in val
            normals.push normal
        when 'TEXCOORD'
          for uv in val
            uvs.push uv
    numberTriangles++
  
  return new TriangleMesh(objectToWorld, Transform.InverseTransform(objectToWorld), false, 
                          numberTriangles, numberTriangles * 3, vertexIndices, positions, 
                          normals, null, uvs)

# ### *createSourceObjects*:
# > **`createSourceObjects`** takes the data from a `<source>` element, e.g.:
#
# > `<float_array>1 1 -1 -1 -1 -1 -1 1 -1</float_array>`
#
# > and turns it into useable objects such as:
#
# > * [**`Vectors`**](geometry.html#vector)
#
# > * [**`Points`**](geometry.html#point)
#
# > * [**`Normals`**](geometry.html#normal)
createSourceObjects = (meshObjects) ->
  sourceObjects = {}
  arrayElementNames = ['bool_array', 'float_array', 'IDREF_array', 'int_array',
                       'Name_array', 'SIDREF_array', 'token_array']
  for meshObject in meshObjects
    for input in meshObject.input
      
      source = input.sourceElement
      if source?
        sourceObjects[input.semantic] or= []
        sourceObjects[input.semantic].semantic = input.semantic
        for own key, val of source
          if key in arrayElementNames
            sourceVals = (+v for v in (getValueOf val).split(' '))
        
        if _.isArray sourceVals
          # > The object type is assumed based on the `semantic` type.
          switch input.semantic
            when 'POSITION'
              for i in [0...sourceVals.length] when i % 3 is 0
                x = sourceVals[i]
                y = sourceVals[i + 1]
                z = sourceVals[i + 2]
                sourceObjects[input.semantic].push new Point(x, y, z)
            when 'NORMAL'
              for i in [0...sourceVals.length] when i % 3 is 0
                x = sourceVals[i]
                y = sourceVals[i + 1]
                z = sourceVals[i + 2]
                sourceObjects[input.semantic].push new Normal(x, y, z)
            when 'TEXCOORD'
              for i in [0...sourceVals.length] when i % 2 is 0
                u = sourceVals[i]
                v = sourceVals[i + 1]
                sourceObjects[input.semantic].push [u, v]
  return sourceObjects

getLightsFrom = (scene) ->
  light_nodes = getObjectsFrom scene, '$..node[?(@.instance_light)]'
  if light_nodes isnt false
    if _.isArray light_nodes
      return (createLight(light_node, scene) for light_node in light_nodes)
    return [createLight light_nodes, scene]
  return []

createLight = (light_node, scene) ->
  lights = []
  lightToWorld = createObjectToWorldTransform light_node

  instanceLights = light_node.instance_light
  for instanceLight in (instanceLights ? [])

    id = if instanceLight.url.substr(0, 1) is '#' then instanceLight.url.substring(1) else instanceLight.url
    light = getObjectsFrom scene, "$..light[?(@.id == '#{id}')]"
    if light is false
      throw COLLADAFileError "There is no `<light>` with the `id` '#{id}'"

    techniqueCommon = getValueOf light.technique_common
    unless techniqueCommon? and not _.isArray techniqueCommon
      throw COLLADAFileError 'A `<light>` must contain 1 `<technique_common>`.'
    unless techniqueCommon.ambient? ^ techniqueCommon.directional? ^ techniqueCommon.point? ^ techniqueCommon.spot?
      throw COLLADAFileError 'A `<light><technique_common>` must contain either 1 `<ambient>` or 1 `<directional>` or 1 `<point>` or 1 `<spot>`.'

    ambient = getValueOf techniqueCommon.ambient
    if ambient?
      console.warn 'AmbientLights are not supported '

    directional = getValueOf techniqueCommon.directional
    if directional?
      if _.isArray directional
        throw COLLADAFileError 'A `<light><technique_common>` may contain at most 1 `<directional>`'
      lights.push createDirectionalLight(lightToWorld, directional)  

    point = getValueOf techniqueCommon.point
    if point?
      if _.isArray point
        throw COLLADAFileError 'A `<light><technique_common>` may contain at most 1 `<point>`'
      lights.push createPointLight(lightToWorld, point)  

    spot = getValueOf techniqueCommon.spot
    if spot?
      if _.isArray spot
        throw COLLADAFileError 'A `<light><technique_common>` may contain at most 1 `<spot>`'
      lights.push createSpotLight(lightToWorld, spot)

  console.log lights
  for l in lights
    console.log l.constructor.name
  return lights

createDirectionalLight = (lightToWorld, directional) ->
  color = getValueOf directional.color
  unless color? and not _.isArray color
    throw COLLADAFileError 'A `<directional>` element must contain 1 `<color>`.'
  [r, g, b] = color.split ' '
  
  direction = new Vector(0, 0, 1)
  direction = Transform.TransformVector lightToWorld, direction
  
  new DistantLight(lightToWorld, RGBSpectrum.FromRGB([r, g, b]), direction)
  
createPointLight = (lightToWorld, point) ->
  color = getValueOf point.color
  unless color? and not _.isArray color
    throw COLLADAFileError 'A `<point>` element must contain 1 `<color>`.'
  [r, g, b] = color.split ' '
  
  new PointLight(lightToWorld, RGBSpectrum.FromRGB([r, g, b]))
  
createSpotLight = (lightToWorld, spot) ->
  color = getValueOf spot.color
  unless color? and not _.isArray color
    throw COLLADAFileError 'A `<directional>` element must contain 1 `<color>`.'
  [r, g, b] = color.split ' '
  
  falloffAngle = getValueOf spot.falloff_angle ? 180
  falloffExponent = getValueOf spot.falloff_exponent ? 0
  falloffStart = Math.pow Math.cos(falloffAngle), falloffExponent
  new SpotLight(lightToWorld, RGBSpectrum.FromRGB([r, g, b]), falloffAngle, falloffStart)

# ___
# ## Exports:

# The **`parseCOLLADASceneDescriptionJSON`** function is added to the global `root` object.
exports.parse = parseCOLLADASceneDescriptionJSON