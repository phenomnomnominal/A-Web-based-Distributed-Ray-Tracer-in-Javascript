# *sceneHandler.coffee* takes the **[JSON][]** version of the **[COLLADA][]** file uploaded by the user and converts it into usable objects such as
# **[`Camera`][1]**s, **[`Light`][2]**s and **[`Shape`][3]**s.
# ___
#
# <!--- URLs --->
# [json]: http://www.json.org/ "JSON"
# [collada]: http://www.collada.org "COLLADA"
# [1]: camera.html#camera "Camera"
# [2]: light.html#light "Light"
# [3]: shape.html#shape "Shape"

# ## Requires:
# Functionality in *sceneHandler.coffee* requires access to the following libraries:

# > * [**`_`**](http://underscorejs.org/) - *underscore.js utility library*
_ = require 'underscore'
# > * [**`jsonpath`**](http://goessner.net/articles/JsonPath/) - *XPath-like functionality for [**JSON**](http://www.json.org/)*
jsonpath = require '../../libraries/jsonpath'

# Other classes from other packages are also required:
  
# * From *raytracer/index.coffee:*
Raytracer = require('../raytracer/').Raytracer
# > * The *camera* package and the following classes:
#
# >> * [**`OrthographicCamera`**](camera.html#orthographic)
#
# >> * [**`PerspectiveCamera`**](camera.html#perspective)
#
# >> * [**`Film`**](camera.html#film)
#
OrthographicCamera = Raytracer.OrthographicCamera
PerspectiveCamera = Raytracer.PerspectiveCamera
Film = Raytracer.Film

# > * The *geometry* package and the following classes:
#
# >> * [**`AnimatedTransform`**](animatedTransform.html#animT)
#
# >> * [**`Vector`**](geometry.html#vector)
#
# >> * [**`Transform`**](transform.html#transform)
#
AnimatedTransform = Raytracer.AnimatedTransform
Vector = Raytracer.Vector
Point = Raytracer.Point
Normal = Raytracer.Normal
Transform = Raytracer.Transform

# ___

# ## Constants:
# Some constants are required for this script:

# > * **`SCENE`** - *Global placeholder for parsed JSON object*
SCENE = {}
# > * **`findInJSON`** - *Renamed* `jsonpath.jsonPath` *function*
findInJSON = jsonpath.jsonPath

# ___

# ## COLLADA Types:
# It is useful to have references to groupings of some valid **[COLLADA][]** data types:
#
# <!--- URLs -->
# [collada]: http://www.collada.org "COLLADA"

# * `arrayElementNames` - valid *array_element* tag names:
arrayElementNames = ['bool_array', 
                     'float_array', 
                     'IDREF_array', 
                     'int_array', 
                     'Name_array', 
                     'SIDREF_array', 
                     'token_array']

# ___

# ## Error Types:
# Some specific Error classes for this script:
  
# > * **`COLLADAFileError`** - *Something is wrong with the supplied COLLADA*
class COLLADAFileError extends Error

# ___

# ## Functions:

# ### *getValueFrom*:
# > **`getValueFrom`** takes an object from the converted **[JSON][]** and finds out the actual value that should be returned. Because we are using the **[xml2json][]** plugin in *extended* mode, all XML nodes are converted into `Array`s which allows this conversion code to be based off the **[COLLADA specification][]** document.
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
#
# <!--- URLs -->
# [json]: http://www.json.org/ "JSON"
# [xml2json]: http://www.fyneworks.com/jquery/xml-to-json/ "xml2json"
# [collada specification]: documents/collada_spec_1_5.pdf "COLLADA Spec"
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
    
# ### *createObjectToWorldTransform*:
# > **`createObjectToWorldTransform`** takes a `<node>` element, extracts the *Translation*, *Rotation* and *Scale* transforms using **[`getTranslation`][1]**, **[`getRotation`][2]** and **[`getScale`][3] and combines them into a single `objectToWorld` **[`Transform`][4]**. The relevant structure is as follows:
#
# <!--- URLs -->
# [1]: #get-translation "getTranslation"
# [2]: #get-rotation "getRotation"
# [3]: #get-scale "getScale"
# [4]: transform.html#transform "Transform"
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
# > **`getTranslation`** takes a `<translate>` element and creates a new *Translate* **[`Transform`][1]**. A `<translate>` element has the following form:
#
# >> `<translate>X Y Z</translate>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
#
# <!--- URLs -->
# [1]: transform.html#transform "Transform"
getTranslation = (translate) ->
  [translateX, translateY, translateZ] = translate.split(' ')
  return Transform.Translate new Vector(+translateX, +translateY, +translateZ)

# ### <section id='get-rotation'>*getRotation*:</section>
# > **`getRotation`** takes a `<rotate>` element and creates a new *Rotate* **[`Transform`][1]. A `<rotate>` element has the following form:
#
# >> `<rotate>X Y Z DEGREES</rotate>`,
#
# > where X, Y and Z are binary flags which indicate which *axis* is being rotated around.
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).  If the `DEGREES` value is exactly divisible by `360`, an identity **[`Transform`][1]** is returned. If none of the `X`, `Y` or `Z` flags are set, a `COLLADAFileError` is thrown.
#
# <!--- URLs -->
# [1]: transform.html#transform "Transform"
getRotation = (rotate) ->
  [axisX, axisY, axisZ, degrees] = rotate.split(" ")
  if +degrees % 360 isnt 0
    if +axisX is 1 then return Transform.RotateX(+degrees)
    else if +axisY is 1 then return Transform.RotateY(+degrees)
    else if +axisZ is 1 then return Transform.RotateZ(+degrees)
    else throw COLLADAFileError 'No axis bit is set in `<rotate>`.'
  else return new Transform()

# ### <section id='get-scale'>*getScale*:</section>
# > **`getScale`** takes a `<scale>` element and creates a new *Scale* **[`Transform`][1]**. A `<scale>` element has the following form:
#
# >> `<scale>X Y Z</scale>`
#
# > Because the data gets extracted as a `String`, it is split and each component is cast to a number (`+`).
#
# <!--- URLs -->
# [1]: transform.html#transform "Transform"
getScale = (scale) ->
  [scaleX, scaleY, scaleZ] = scale.split(" ")
  return Transform.Scale +scaleX, +scaleY, +scaleZ

# ### *parseCOLLADASceneDescriptionJSON*:
# > **`parseCOLLADASceneDescriptionJSON`** takes the whole **[JSON][]** string received by the server when the user uploads a **[COLLADA][]** file and parses it to an `Object`. It is then responsible for breaking the generation of the **`SCENE`** down into several smaller tasks:
# 
# > 1. Extract **[`Camera`][1]** `Object`s from JSON
#
# > 2. Extract **[`Shape`][2]** `Object`s from JSON
#
# <!--- URLs -->
# [json]: http://www.json.org/ "JSON"
# [collada]: http://www.collada.org "COLLADA"
# [1]: camera.html#camera "Camera"
# [2]: shape.html "Shape" 
parseCOLLADASceneDescriptionJSON = (sceneDescriptionJSON) ->
  SCENE = JSON.parse sceneDescriptionJSON
  console.log getCamerasIn SCENE
  console.log getGeometryIn SCENE

# ### *getCamerasIn*:
# > **`getCamerasIn`** performs the task of finding all the `<node>` elements who have `<instance_camera>` child elements within the parsed **[COLLADA][]** XML document. The **[JSONPath][]** expression:
#
# >> `$..node[?(@.instance_camera)]`
#
# > searches for all `node` objects with the property `instance_camera`, and returns an `Array` of the results. 
#
# > Each of the results are passed to **[`createCamera`][1]** to determine the **[`Camera`][1]` type (**[`OrthographicCamera`][3]** or **[`PerspectiveCamera`][4]**) and create the `Object`.
#
# <!--- URLs -->
# [collada]: http://www.collada.org "COLLADA"
# [jsonpath]: http://goessner.net/articles/JsonPath/ "JSONPath"
# [1]: #create-camera "createCamera"
# [2]: camera.html#camera "Camera"
# [3]: camera.html#orthographic "OrthographicCamera"
# [4]: camera.html#perspective "PerspectiveCamera"
getCamerasIn = (scene) ->
  camera_nodes = findInJSON scene, '$..node[?(@.instance_camera)]'
  sceneCameras = []
  for camera_node in camera_nodes
    sceneCameras = sceneCameras.concat createCamera(camera_node)

# ### <section id='create-camera'>*createCamera*:</section>
# > **`createCamera`** uses the well-defined structure of the **[COLLADA SCHEMA][]** to extract the relevant information needed to create a **[`Camera`][1]** `Object` from an `<instance_camera>` element. The relevant structure is as follows:
#
# <!--- URLs -->
# [collada schema]: http://www.collada.org/2005/COLLADASchema.xsd "COLLADA Schema"
# [1]: camera.html#camera "Camera"
createCamera = (camera_node) ->
  cameras = []
  instanceCameras = camera_node.instance_camera
  # > * A `<node>` element may have **0 or more** `<instance_camera>` child elements, so we must iterate over all of them.
  for instanceCamera in instanceCameras
    # > * An `<instance_camera>` element must have an `url` attribute which refers to a unique `id` of a `<camera>` element - searching for that `id` will return exactly one `<camera>` element.
    url = if instanceCamera.url.substr(0, 1) is "#" then instanceCamera.url.substring(1) else instanceCamera.url
    camera = getValueFrom findInJSON SCENE, "$..camera[?(@.id == '#{url}')]"
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
            perspective = getValueFrom techniqueCommon.perspective
            cameras.push createPerspectiveCamera(camToWorld, perspective)
          else if techniqueCommon.orthographic? and techniqueCommon.orthographic.length is 1
            orthographic = getValueFrom techniqueCommon.orthographic
            cameras.push createOrthographicCamera(camToWorld, orthographic)
          # > If the structure is correct, a new **[`OrthographicCamera]`[1]** or [**`PerspectiveCamera`**]() is created.
          #
          # > Otherwise the **[COLLADA][]** document doesn't meet the **[COLLADA specification][]**, so an `Error` is thrown.
          #
          # <!--- URLs -->
          # [1]: camera.html#orthographic "Orthographic"
          # [2]: camera.html#perspective "Perspective"
          # [collada]: http://www.collada.org "COLLADA"
          # [collada specification]: documents/collada_spec_1_5.pdf
          else
            throw COLLADAFileError 'An `<optics>` must have a `<technique_common>` child with either a `<perspective>` child or an `<orthographic>` child.'
        else
          throw COLLADAFileError 'An `<optics>` must have exactly 1 `<technique_common>` child.'
      else
        throw COLLADAFileError 'A `<camera>` must have exactly 1 `<optics>` child.'
    else
      throw COLLADAFileError "There is no `<camera>` element with the `id` '#{instanceCamera.url}'"
    
  # > All created [**`Camera`**](camera.html#camera)s are returned to the
  # `SCENE`.
  return cameras

# ### *createPerspectiveCamera*:
# > **`createPerspectiveCamera`** takes a `<perspective>` element and creates a new **[`PerspectiveCamera`][]**. A `<perspective>` element must contain:
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
# > If the structure is correct, a new **[`PerspectiveCamera`][1]** is created. Otherwise the **[COLLADA][]** document doesn't meet the **[COLLADA specification][]**, so a `COLLADAFileError` is thrown.
#
# <!--- URLs -->
# [1]: camera.html#perspective "Perspective"
# [collada]: http://www.collada.org "COLLADA"
# [collada specification]: documents/collada_spec_1_5.pdf
createPerspectiveCamera = (camToWorld, perspective) ->
  camToWorld = new AnimatedTransform(camToWorld, 0, camToWorld, 0)
  if perspective.znear?
    near = getValueFrom perspective.znear
  else
    throw COLLADAFileError 'A `<perspective>` element must have exactly 1 `<znear>` child.'
  if perspective.zfar?
    far = getValueFrom perspective.zfar
  else 
    throw COLLADAFileError 'A `<perspective>` element must have exactly 1 `<zfar>` child.'
  if perspective.xfov then xfov = getValueFrom perspective.xfov else null
  if perspective.yfov then yfov = getValueFrom perspective.yfov else null
  if perspective.aspect_ratio then aspectRatio = getValueFrom perspective.aspect_ratio else null
  if xfov? and yfov? and not aspectRatio?
    aspectRatio = xfov / yfov
  else if xfov? and aspectRatio? and not yfov?
    yfov = xfov / aspectRatio
  else if yfov? and aspectRatio? and not xfov?
    xfov = yfov * aspectRatio
  else if not xfov? and not yfox?
    throw COLLADAFileError 'A `<perspective>` must have either a `<xfov>` or a `<yfov>` child.'
  `// TODO else aspectRatio = getAspectRatio()`
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]  
  return new PerspectiveCamera(camToWorld, 0, 0, new Film(200, 200),
                               xfov, near, far, screenWindow, 0, 0)

# ### *createOrthographicCamera*:
# > **`createOrthographicCamera`** takes a `orthographic>` element and creates a new **[`OrthographicCamera`][1]**. A `<orthographic>` element must contain:
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
# > If the structure is correct, a new **[`OrthographicCamera`][1]** is created. Otherwise the **[COLLADA][]** document doesn't meet the **[COLLADA specification][]**, so a `COLLADAFileError` is thrown.
#
# <!--- URLs -->
# [1]: camera.html#orthographic "Orthographic"
# [collada]: http://www.collada.org "COLLADA"
# [collada specification]: documents/collada_spec_1_5.pdf
createOrthographicCamera = (camToWorld, orthographic) ->
  camToWorld = new AnimatedTransform(camToWorld, 0, camToWorld, 0)
  if orthographic.znear?
    near = getValueFrom orthographic.znear
  else
    throw COLLADAFileError 'An `<orthographic>` must have exactly 1 `<znear>` child.'
  if orthographic.zfar?
    far = getValueFrom orthographic.zfar
  else throw COLLADAFileError 'An `<orthographic>` must have exactly 1 `<zfar>` child.'
  if orthographic.xmag? then xmag = getValueFrom orthographic.xmag
  if orthographic.ymag? then ymag = getValueFrom orthographic.ymag
  if orthographic.aspect_ratio? then aspectRatio = getValueFrom orthographic.aspect_ratio
  if xmag? and ymag? and not aspectRatio?
    aspectRatio = (xmag / 2) / (ymag / 2)
  else if xmag? and aspectRatio? and not ymag?
    ymag = (xmag / 2) / aspectRatio
  else if ymag? and aspectRatio? and not xmag?
    xmag = (ymag / 2) * aspectRaio
  else if not xmag? and not ymag?
    throw  COLLADAFileError 'An `<orthographic>` must have either a `<xmag>` or a `<ymag>` child.'
  `// TODO else aspectRatio = getAspectRatio()`
  if aspectRatio > 1
    screenWindow = [-aspectRatio, aspectRatio, -1, 1]
  else 
    screenWindow = [-1, 1, -1 / aspectRatio, 1 / aspectRatio]
  return new OrthographicCamera(camToWorld, 0, 0, new Film(200, 200),
                                near, far, screenWindow, 0, 0)

getGeometryIn = (scene) ->
  geometry_nodes = findInJSON scene, '$..node[?(@.instance_geometry)]'
  sceneGeometry = []
  for geometry_node in geometry_nodes
    sceneGeometry = sceneGeometry.concat createGeometry(geometry_node)
    
createGeometry = (geometry_node) ->
  geometries = []
  instanceGeometries = geometry_node.instance_geometry
  for instanceGeometry in instanceGeometries
    url = if instanceGeometry.url.substr(0, 1) is "#" then instanceGeometry.url.substring(1) else instanceGeometry.url
    geometry = getValueFrom findInJSON SCENE, "$..geometry[?(@.id == '#{url}')]"
    if geometry? and geometry isnt false
      objectToWorld = createObjectToWorldTransform geometry_node
      mesh = getValueFrom geometry.mesh
      if mesh? and not _.isArray mesh        
        vertices = getVerticesFrom mesh
        primitives = []
        `// TODO: Handle <polygons> elements`
        polylists = getPolylistsFrom mesh
        primitives = primitives.concat polylists
        `// TODO: Handle <triangles> elements`
        `// TOTO: Handle <tristrips> elements`
      geometries = geometries.concat createTriangleMesh(objectToWorld, vertices, primitives)
  return

getVerticesFrom = (mesh) ->
  positionSemantic = 0
  if mesh.vertices? and mesh.vertices.length is 1
    vertices = getValueFrom mesh.vertices
    inputs = []
    if vertices.input?
      for vertexInput in vertices.input
        if vertexInput.semantic?
          if vertexInput.source?
            semantic = getValueFrom vertexInput.semantic
            if semantic is 'POSITION'
              positionSemantic++
            source = getValueFrom vertexInput.source
            id = if source.substr(0, 1) is '#' then source.substring(1) else source
            sourceEl = getValueFrom findInJSON(mesh, "$..source[?(@.id == '#{id}')]")
            inputObj =
              semantic: semantic
              sourceElement: sourceEl
            inputs.push inputObj
          else
            throw COLLADAFileError 'An `<input> (unshared)` must have a `source` attribute.'
        else 
          throw COLLADAFileError 'An `<input> (unshared)` must have a `semantic` attribute.'
    else
      throw COLLADAFileError 'A `<vertices>` must have at least 1 `<input>` child.'
  else
    throw COLLADAFileError 'A `<mesh>` must have exactly 1 `<vertices>` child.'
  unless positionSemantic is 1
    throw COLLADAFileError 'Exactly one `<vertices>` `<input>` child must have semantic="POSITION"'
  return [input: inputs]
  
getPolylistsFrom = (mesh) ->
  vertexSemantic = 0
  polylistInputs = []
  if mesh.polylist?
    polylists = mesh.polylist
    for polylist in polylists
      inputs = []
      if polylist.input?
        for polylistInput in polylist.input
          if polylistInput.semantic?
            if polylistInput.source?
              if polylistInput.offset?
                semantic = getValueFrom polylistInput.semantic
                source = getValueFrom polylistInput.source
                id = if source.substr(0, 1) is '#' then source.substring(1) else source
                if semantic is 'VERTEX'
                  vertexSemantic++
                else
                  sourceEl = getValueFrom findInJSON(mesh, "$..source[?(@.id == '#{id}')]")
                inputObj = 
                  semantic: semantic, 
                  source: id,
                  sourceElement: sourceEl,
                  offset: getValueFrom(polylistInput.offset)
                inputs.push inputObj
              else
                throw COLLADAFileError 'An `<input> (shared)` must have an `offset` attribute.'
            else
              throw COLLADAFileError 'An `<input> (shared)` must have a `source` attribute.'
          else
            throw COLLADAFileError 'An `<input> (shared)` must have a `semantic` attribute.'
      if polylist.vcount?
        if polylist.vcount.length is 1
          polylistvcount = (+v for v in (getValueFrom polylist.vcount).split(' '))
        else
          throw COLLADAFileError 'A `<polylist>` may only have 0 or 1 `<vcount>` child.'
      if polylist.p?
        if polylist.p.length is 1
          polylistp = (+p for p in (getValueFrom polylist.p).split(' '))
        else 
          throw COLLADAFileError 'A `<polylist>` may only have 0 or 1 `<p>` child.'
      polylistInputs.push input: inputs, vcount: polylistvcount, p: polylistp
    unless vertexSemantic is 1 and polylist.input?
      throw COLLADAFileError 'If a `<polylist>` has `<input>` children, exactly one of them must have semantic="VERTEX"'
  return polylistInputs

createTriangleMesh = (objectToWorld, vertices, primitives) ->
  worldToObject = Transform.InverseTransform(objectToWorld)
  positionSource = getValueFrom findInJSON(vertices, "$..*[?(@.semantic == 'POSITION')].sourceElement")
  positions = []
  for own key, val of positionSource
    if key in arrayElementNames
      positionVals = (+v for v in (getValueFrom val).split(' '))
  if positionVals?
    for i in [0...positionVals.length] when i % 3 is 0
      positions.push new Point(positionVals[i], positionVals[i + 1], positionVals[i + 2])
  normalSource = getValueFrom findInJSON(primitives, "$..*[?(@.semantic == 'NORMAL')].sourceElement")
  normals = []
  for own key, val of normalSource
    if key in arrayElementNames
      normalVals = (+v for v in (getValueFrom val).split(' '))
  if normalVals?
    for i in [0...normalVals.length] when i % 3 is 0
      normals.push new Normal(normalVals[i], normalVals[i + 1], normalVals[i + 2])
  return

# ___
# ## Exports:

# The **`parseCOLLADASceneDescriptionJSON`** function is added to the global `root` object.
exports.parse = parseCOLLADASceneDescriptionJSON