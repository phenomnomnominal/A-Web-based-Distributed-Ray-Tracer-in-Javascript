$(document).ready ->
  module 'Camera - constructor'

  test 'Test for Errors when passing incorrect arguments to the required
        parameters of the Camera constructor:', ->
    expect 20
    ok Camera?,
      'If we create a Camera by calling "new Camera" with no arguments'
    raises (-> c = new Camera())
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must
       be defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into
                               the constructor as cameraToWorld'
    raises (-> c = new Camera(notAnimatedTransform))
      ,/Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it into
              the constructor'
    raises (-> c = new Camera(c2w))
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterOpen'
    raises (-> c = new Camera(c2w, notNumber))
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be a
       Number."'
    so = 0
    ok so?,
      'If we create a shutterOpen Number and pass it into the constructor'
    raises (-> c = new Camera(c2w, so))
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterClose'
    raises (-> c = new Camera(c2w, so, notNumber))
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be a
       Number."'
    sc = 10
    ok sc?,
      'If we create a shutterClose Number and pass it into the constructor'
    raises (-> c = new Camera(c2w, so, sc))
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises (-> c = new Camera(c2w, so, sc, notFilm))
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    ok film?, 'If we create a film Film and pass it into the constructor'
    c = new Camera(c2w, so, sc, film)
    ok c? and c.constructor.name is 'Camera', 'we will get a Camera Object.'
    scaleT = Transform.Scale(10, 10, 10)
    scale = new AnimatedTransform(scaleT, 0, scaleT, 0)
    ok scale?, 'However, if we pass an AnimatedTransform with a scale factor
                into the constructor'
    raises (-> c = new Camera(scale, so, sc, film))
      , /Camera Constructor Error: cameraToWorld shouldn\'t have any scale factors in it./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld
       shouldn\'t have any scale factors in it."'
      
  test 'Test creating a new Camera, supplying valid arguments to the
        constructor:', ->
    expect 10
    ok Camera?, 'If we create a Camera by calling "new Camera" with a set of
                 valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    ok c? and c.constructor.name is 'Camera',
      'the constructor should return a Camera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform',
      'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber(c.shutterOpen), 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber(c.shutterClose), 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film.'
    
  module 'Camera - Prototype functions'
  
  test 'Test that all Prototype functions exist on a Camera:', ->
    expect 3
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    ok c?, 'If we create a Camera'
    ok c.generateRay?, 'it should have a "generateRay" function'
    ok c.generateRayDifferential?, 'and a "generateRayDifferential" function.'
    
  test 'Test for "Not Implemented" Error when calling "generateRay" on a
        Camera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default Camera instance and call its "generateRay"
            function'
    raises (-> c.generateRay(sample))
      , /Not Implemented Error: generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented Error: generateRay must be
       implemented by Camera subclasses."'

  test 'Test for "Not Implemented" Error when calling
        "generateRayDifferential" on a Camera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default Camera instance and call its
            "generateRayDifferential" function'
    raises (-> c.generateRayDifferential(sample))
      , /Not Implemented Error: generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented Error: generateRay must be
       implemented by Camera subclasses." This Error is thrown because
       although "Camera.generateRayDifferential" has a default implementation,
       it relies on a subclass specific "generateRay" implementation.'
        
  module 'ProjectiveCamera - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the required
        parameters of the ProjectiveCamera constructor:', ->
    expect 34
    ok ProjectiveCamera?, 'If we create a ProjectiveCamera by calling
                           "new ProjectiveCamera" with no arguments'
    raises (-> c = new ProjectiveCamera())
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into
                               the constructor as cameraToWorld'
    raises (-> c = new ProjectiveCamera(notAnimatedTransform))
      , /Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it
              into the constructor'
    raises (-> c = new ProjectiveCamera(c2w))
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterOpen'
    raises (-> c = new ProjectiveCamera(c2w, notNumber))
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       a Number."'
    so = 0
    ok so?,
      'If we create a shutterOpen Number and pass it into the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so))
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterClose'
    raises (-> c = new ProjectiveCamera(c2w, so, notNumber))
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       a Number."'
    sc = 10
    ok sc?,
      'If we create a shutterClose Number and pass it into the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so, sc))
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, notFilm))
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    ok film?, 'If we create a film Film and pass it into the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film))
      , /ProjectiveCamera Constructor Error: projectiveTransform must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error:
       projectiveTransform must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, 'If we pass a non-Transform Object into the constructor
                       as projectiveTransform'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, notTransform))
      , /ProjectiveCamera Constructor Error: projectiveTransform must be a Transform./,
      'an Error is thrown: "ProjectiveCamera Constructor Error:
       projectiveTransform must be a Transform."'
    pt = Transform.Orthographic(0, 100)
    ok pt?, 'If we create a projectiveTransform Transform and pass it into
             the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, pt))
      , /ProjectiveCamera Constructor Error: screenWindow must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be defined."'
    notArray = 'NOT AN ARRAY'
    ok notArray?, 'If we pass a non-Array Object into the constructor as
                   screenWindow'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, pt, notArray))
      , /ProjectiveCamera Constructor Error: screenWindow must be an Array./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be an Array."'
    sw = [-1, 1, -1, 1]
    ok sw?,
      'If we create a screenWindow Array and pass it into the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, pt, sw))
      , /ProjectiveCamera Constructor Error: lensRadius must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as lensRadius'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, notNumber))
      , /ProjectiveCamera Constructor Error: lensRadius must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be a Number."'
    lr = 1
    ok lr?, 'If we create a lensRadius Number and pass it into the constructor'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr))
      , /ProjectiveCamera Constructor Error: focalDistance must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as focalDistance'
    raises (-> c = new ProjectiveCamera(c2w, so, sc, film,
                                        pt, sw, lr, notNumber))
      , /ProjectiveCamera Constructor Error: focalDistance must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be a Number."'
    fd = 2
    ok fd?,
      'If we create a focalDistance Number and pass it into the constructor'
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    ok c? and c.constructor.name is 'ProjectiveCamera',
      'we will get a ProjectiveCamera Object.'
    
  test 'Test creating a new ProjectiveCamera, supplying valid arguments to the
        constructor:', ->
    expect 82
    ok ProjectiveCamera?,
      'If we create a ProjectiveCamera by calling "new ProjectiveCamera" with
       a set of valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    pt = Transform.Orthographic(0, 100)
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    ok c? and c.constructor.name is 'ProjectiveCamera',
      'the constructor should return a ProjectiveCamera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform',
      'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber(c.shutterOpen), 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber(c.shutterClose), 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film'
    ok c.cameraToScreen?, 'and a property named "cameraToScreen"'
    ok c.cameraToScreen.constructor.name is 'Transform', 'that is a Transform'
    ok c.screenToRaster?, 'and a property named "screenToRaster"'
    ok c.screenToRaster.constructor.name is 'Transform', 'that is a Transform:'
    r2sInverse = s2rMatrix = new Matrix4x4([[100,  0, 0, 100],
                                            [0, -100, 0, 100],
                                            [0,    0, 1,   0],
                                            [0,    0, 0,   1]])
    r2sMatrix = s2rInverse = new Matrix4x4([[0.01,  0, 0, -1],
                                            [0, -0.01, 0,  1],
                                            [0,     0, 1,  0],
                                            [0,     0, 0,  1]])
    for i in [0...c.screenToRaster.matrix.m.length]
      for j in [0...c.screenToRaster.matrix.m[i].length]
        equalWithin c.screenToRaster.matrix.m[i][j], s2rMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{s2rMatrix.m[i][j]}"
    for i in [0...c.screenToRaster.inverse.m.length]
      for j in [0...c.screenToRaster.inverse.m[i].length]
        equalWithin c.screenToRaster.inverse.m[i][j], s2rInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{s2rInverse.m[i][j]}"
    ok c.rasterToScreen?, 'and a property named "rasterToScreen"'
    ok c.rasterToScreen.constructor.name is 'Transform', 'that is a Transform:'
    for i in [0...c.rasterToScreen.matrix.m.length]
      for j in [0...c.rasterToScreen.matrix.m[i].length]
        equalWithin c.rasterToScreen.matrix.m[i][j], r2sMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{r2sMatrix.m[i][j]}"
    for i in [0...c.rasterToScreen.inverse.m.length]
      for j in [0...c.rasterToScreen.inverse.m[i].length]
        equalWithin c.rasterToScreen.inverse.m[i][j], r2sInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{r2sInverse.m[i][j]}"
    ok c.rasterToCamera?, 'and a property named "rasterToCamera"'
    ok c.rasterToCamera.constructor.name is 'Transform', 'that is a Transform'
    
  module 'ProjectiveCamera - Prototype functions'

  test 'Test that all Prototype functions exist on a ProjectiveCamera:', ->
    expect 3
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    pt = Transform.Orthographic(0, 100)
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    ok c?, 'If we create a ProjectiveCamera'
    ok c.generateRay?, 'it should have a "generateRay" function'
    ok c.generateRayDifferential?, 'and a "generateRayDifferential" function.'
    
  test 'Test for "Not Implemented" Error when calling "generateRay" on a
    ProjectiveCamera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    pt = Transform.Orthographic(0, 100)
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default ProjectiveCamera instance and call its
      "generateRay" function'
    raises (-> c.generateRay())
      , /Not Implemented Error: generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented Error: generateRay must be
       implemented by Camera subclasses."'

  test 'Test for "Not Implemented" Error when calling "generateRayDifferential"
    on a ProjectiveCamera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    pt = Transform.Orthographic(0, 100)
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default ProjectiveCamera instance and call its
      "generateRayDifferential" function'
    raises (-> c.generateRayDifferential(sample))
      , /Not Implemented Error: generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented Error: generateRay must be
       implemented by Camera subclasses." This Error is thrown because
       although "Camera.generateRayDifferential" has a default implementation,
       it relies on a subclass specific "generateRay" implementation.'
         
  module 'OrthographicCamera - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the required
        parameters of the OrthographicCamera constructor:', ->
    expect 36
    ok OrthographicCamera?, 'If we create a OrthographicCamera by calling
                             "new OrthographicCamera" with no arguments'
    raises (-> c = new OrthographicCamera())
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into
                               the constructor as cameraToWorld'
    raises (-> c = new OrthographicCamera(notAnimatedTransform))
      , /Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it
              into the constructor'
    raises (-> c = new OrthographicCamera(c2w))
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterOpen'
    raises (-> c = new OrthographicCamera(c2w, notNumber))
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       a Number."'
    so = 0
    ok so?,
      'If we create a shutterOpen Number and pass it into the constructor'
    raises (-> c = new OrthographicCamera(c2w, so))
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterClose'
    raises (-> c = new OrthographicCamera(c2w, so, notNumber))
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       a Number."'
    sc = 10
    ok sc?,
      'If we create a shutterClose Number and pass it into the constructor'
    raises (-> c = new OrthographicCamera(c2w, so, sc))
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises (-> c = new OrthographicCamera(c2w, so, sc, notFilm))
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    notNumber = 'NOT A NUMBER'
    ok film?, 'If we create a film Film and pass it into the constructor'
    ok notNumber?,
      'along with a non-Number Object as near'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film, notNumber))
      , /OrthographicCamera Constructor Error: near must be a Number./,
      'an Error is thrown: "OrthographicCamera Constructor Error:
       near must be a Number."'
    near = 0
    notNumber = 'NOT A NUMBER'
    ok near?,
      'If we create a near Number and pass it into the constructor'
    ok notNumber?,
      'along with a non-Number Object as far'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film, near, notNumber))
      , /OrthographicCamera Constructor Error: far must be a Number./,
      'an Error is thrown: "OrthographicCamera Constructor Error:
       far must be a Number."'
    far = 1
    ok far?,
      'If we create a far Number and pass it into the constructor'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film, near, far))
      , /ProjectiveCamera Constructor Error: screenWindow must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be defined."'
    notArray = 'NOT AN ARRAY'
    ok notArray?,
      'If we pass a non-Array Object into the constructor as screenWindow'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film,
                                          near, far, notArray))
      , /ProjectiveCamera Constructor Error: screenWindow must be an Array./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be an Array."'
    sw = [-1, 1, -1, 1]
    ok sw?, 'If we create a screenWindow Array and pass it into the constructor'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film, near, far, sw))
      , /ProjectiveCamera Constructor Error: lensRadius must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as lensRadius'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film,
                                          near, far, sw, notNumber))
      , /ProjectiveCamera Constructor Error: lensRadius must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be a Number."'
    lr = 1
    ok lr?, 'If we create a lensRadius Number and pass it into the constructor'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film,
                                          near, far, sw, lr))
      , /ProjectiveCamera Constructor Error: focalDistance must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as focalDistance'
    raises (-> c = new OrthographicCamera(c2w, so, sc, film,
                                          near, far, sw, lr, notNumber))
      , /ProjectiveCamera Constructor Error: focalDistance must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be a Number."'
    fd = 2
    ok fd?,
      'If we create a focalDistance Number and pass it into the constructor'
    c = new OrthographicCamera(c2w, so, sc, film, near, far, sw, lr, fd)
    ok c? and c.constructor.name is 'OrthographicCamera',
      'we will get a OrthographicCamera Object.'
      
  test 'Test creating a new OrthographicCamera, supplying valid arguments to the
        constructor:', ->
    expect 88
    ok OrthographicCamera?,
      'If we create a OrthographicCamera by calling "new OrthographicCamera"
       with a set of valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    near = 0
    far = 100
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new OrthographicCamera(c2w, so, sc, film, near, far, sw, lr, fd)
    ok c? and c.constructor.name is 'OrthographicCamera',
      'the constructor should return a OrthographicCamera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform',
      'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber(c.shutterOpen), 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber(c.shutterClose), 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film'
    ok c.cameraToScreen?, 'and a property named "cameraToScreen"'
    ok c.cameraToScreen.constructor.name is 'Transform', 'that is a Transform'
    ok c.screenToRaster?, 'and a property named "screenToRaster"'
    ok c.screenToRaster.constructor.name is 'Transform', 'that is a Transform:'
    r2sInverse = s2rMatrix = new Matrix4x4([[100,  0, 0, 100],
                                            [0, -100, 0, 100],
                                            [0,    0, 1,   0],
                                            [0,    0, 0,   1]])
    r2sMatrix = s2rInverse = new Matrix4x4([[0.01,  0, 0, -1],
                                            [0, -0.01, 0,  1],
                                            [0,     0, 1,  0],
                                            [0,     0, 0,  1]])
    for i in [0...c.screenToRaster.matrix.m.length]
      for j in [0...c.screenToRaster.matrix.m[i].length]
        equalWithin c.screenToRaster.matrix.m[i][j], s2rMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{s2rMatrix.m[i][j]}"
    for i in [0...c.screenToRaster.inverse.m.length]
      for j in [0...c.screenToRaster.inverse.m[i].length]
        equalWithin c.screenToRaster.inverse.m[i][j], s2rInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{s2rInverse.m[i][j]}"
    ok c.rasterToScreen?, 'and a property named "rasterToScreen"'
    ok c.rasterToScreen.constructor.name is 'Transform', 'that is a Transform:'
    for i in [0...c.rasterToScreen.matrix.m.length]
      for j in [0...c.rasterToScreen.matrix.m[i].length]
        equalWithin c.rasterToScreen.matrix.m[i][j], r2sMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{r2sMatrix.m[i][j]}"
    for i in [0...c.rasterToScreen.inverse.m.length]
      for j in [0...c.rasterToScreen.inverse.m[i].length]
        equalWithin c.rasterToScreen.inverse.m[i][j], r2sInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{r2sInverse.m[i][j]}"
    ok c.rasterToCamera?, 'and a property named "rasterToCamera"'
    ok c.rasterToCamera.constructor.name is 'Transform', 'that is a Transform'
    ok c.dxCamera?, 'and a property named "dxCamera"'
    ok c.dxCamera.constructor.name is 'Vector', 'that is a Vector'
    dxExpected = new Vector(0.01, 0, 0)
    ok Vector.Equals(c.dxCamera, dxExpected), 'which is equal to (0.01, 0, 0)'
    ok c.dyCamera?, 'and a property named "dyCamera"'
    ok c.dyCamera.constructor.name is 'Vector', 'that is a Vector'
    dyExpected = new Vector(0, -0.01, 0)
    ok Vector.Equals(c.dyCamera, dyExpected), 'which is equal to (0, -0.01, 0)'
  
  module 'OrthographicCamera - Prototype functions'
  
  test 'Test that all Prototype functions exist on a OrthographicCamera:', ->
    expect 3
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    near = 0
    far = 100
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new OrthographicCamera(c2w, so, sc, film, near, far, sw, lr, fd)
    ok c?, 'If we create a OrthographicCamera'
    ok c.generateRay?, 'it should have a "generateRay" function'
    ok c.generateRayDifferential?, 'and a "generateRayDifferential" function.'
    
  test 'Test that "generateRay" works correctly for OrthographicCamera
        instances', ->
    expect 7
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    near = 0
    far = 100
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new OrthographicCamera(c2w, so, sc, film, near, far, sw, lr, fd)
    sample = imageX: 0, imageY: 0, time: 0
    ok sample?, 'If we create a mock sample object and pass it as an argument'
    ok c?, 'to the "generateRay" function of an OrthographicCamera instance'
    [weight, ray] = c.generateRay sample
    ok weight?, 'a "weight" value should be returned'
    equal weight, 1, 'which should equal 1,'
    ok ray? and ray.constructor.name is 'Ray',
      'as well as a "ray" value that is a Ray.'
    ok Point.Equals(ray.origin, new Point(-1, 1, 0)),
      'ray.origin should be equal to (-1, 1, 0) and'
    equal ray.time, 0, 'ray.time should be equal to 0.'
    
  test 'Test that "generateRayDifferential" works correctly for
        OrthographicCamera instances', ->
    expect 10
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    near = 0
    far = 100
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new OrthographicCamera(c2w, so, sc, film, near, far, sw, lr, fd)
    sample = imageX: 0, imageY: 0, time: 0
    ok sample?, 'If we create a mock sample object and pass it as an argument'
    ok c?, 'to the "generateRayDifferential" function of an OrthographicCamera
            instance'
    [weight, rayDiff] = c.generateRayDifferential sample
    ok weight?, 'a "weight" value should be returned'
    equal weight, 1, 'which should equal 1,'
    ok rayDiff? and rayDiff.constructor.name is 'RayDifferential',
      'as well as a "rayDiff" value that is a RayDifferential.'
    ok Point.Equals(rayDiff.origin, new Point(-1, 1, 0)),
      'rayDiff.origin should be equal to (-1, 1, 0),'
    ok Point.Equals(rayDiff.rayXOrigin, new Point(-0.99, 1, 0)),
      'rayDiff.rayXOrigin should be equal to (-0.99, 1, 0),'
    ok Point.Equals(rayDiff.rayYOrigin, new Point(-1, 0.99, 0)),
      'rayDiff.rayYOrigin should be equal to (-1, 0.99, 0) and'
    equal rayDiff.time, 0, 'rayDiff.time should be equal to 0,'
    ok rayDiff.hasDifferentials, 'rayDiff.hasDifferentials should be true.'

  module 'PerspectiveCamera - constructor'

  test 'Test for Errors when passing incorrect arguments to the required
        parameters of the PerspectiveCamera constructor:', ->
    expect 38
    ok PerspectiveCamera?, 'If we create a PerspectiveCamera by calling
                            "new PerspectiveCamera" with no arguments'
    raises (-> c = new PerspectiveCamera())
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into
                               the constructor as cameraToWorld'
    raises (-> c = new PerspectiveCamera(notAnimatedTransform))
      , /Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be
       an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it
                into the constructor'
    raises (-> c = new PerspectiveCamera(c2w))
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterOpen'
    raises (-> c = new PerspectiveCamera(c2w, notNumber))
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be
       a Number."'
    so = 0
    ok so?,
      'If we create a shutterOpen Number and pass it into the constructor'
    raises (-> c = new PerspectiveCamera(c2w, so))
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as shutterClose'
    raises (-> c = new PerspectiveCamera(c2w, so, notNumber))
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be
       a Number."'
    sc = 10
    ok sc?,
      'If we create a shutterClose Number and pass it into the constructor'
    raises (-> c = new PerspectiveCamera(c2w, so, sc))
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, notFilm))
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    notNumber = 'NOT A NUMBER'
    ok film?, 'If we create a film Film and pass it into the constructor'
    ok notNumber?,
      'along with a non-Number Object as fieldOfView'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film, notNumber))
      , /PerspectiveCamera Constructor Error: fieldOfView must be a Number./,
      'an Error is thrown: "PerspectiveCamera Constructor Error:
       fieldOfView must be a Number."'
    fov = 45
    ok notNumber?,
      'along with a non-Number Object as near'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film, fov, notNumber))
      , /PerspectiveCamera Constructor Error: near must be a Number./,
      'an Error is thrown: "PerspectiveCamera Constructor Error:
       near must be a Number."'
    near = 0.01
    notNumber = 'NOT A NUMBER'
    ok near?,
      'If we create a near Number and pass it into the constructor'
    ok notNumber?,
      'along with a non-Number Object as far'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film,
                                         fov, near, notNumber))
      , /PerspectiveCamera Constructor Error: far must be a Number./,
      'an Error is thrown: "PerspectiveCamera Constructor Error:
       far must be a Number."'
    far = 1000
    ok far?,
      'If we create a far Number and pass it into the constructor'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far))
      , /ProjectiveCamera Constructor Error: screenWindow must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be defined."'
    notArray = 'NOT AN ARRAY'
    ok notArray?,
      'If we pass a non-Array Object into the constructor as screenWindow'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film,
                                         fov, near, far, notArray))
      , /ProjectiveCamera Constructor Error: screenWindow must be an Array./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow
       must be an Array."'
    sw = [-1, 1, -1, 1]
    ok sw?, 'If we create a screenWindow Array and pass it into the constructor'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw))
      , /ProjectiveCamera Constructor Error: lensRadius must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as lensRadius'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film,
                                         fov, near, far, sw, notNumber))
      , /ProjectiveCamera Constructor Error: lensRadius must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must
       be a Number."'
    lr = 1
    ok lr?, 'If we create a lensRadius Number and pass it into the constructor'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film,
                                         fov, near, far, sw, lr))
      , /ProjectiveCamera Constructor Error: focalDistance must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?,
      'If we pass a non-Number Object into the constructor as focalDistance'
    raises (-> c = new PerspectiveCamera(c2w, so, sc, film,
                                         fov, near, far, sw, lr, notNumber))
      , /ProjectiveCamera Constructor Error: focalDistance must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance
       must be a Number."'
    fd = 2
    ok fd?,
      'If we create a focalDistance Number and pass it into the constructor'
    c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw, lr, fd)
    ok c? and c.constructor.name is 'PerspectiveCamera',
      'we will get a PerspectiveCamera Object.'

  test 'Test creating a new PerspectiveCamera, supplying valid arguments to the
        constructor:', ->
    expect 92
    ok PerspectiveCamera?,
      'If we create a PerspectiveCamera by calling "new PerspectiveCamera"
       with a set of valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    fov = 45
    near = 0.01
    far = 1000
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw, lr, fd)
    ok c? and c.constructor.name is 'PerspectiveCamera',
      'the constructor should return a PerspectiveCamera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform',
      'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber(c.shutterOpen), 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber(c.shutterClose), 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film'
    ok c.cameraToScreen?, 'and a property named "cameraToScreen"'
    ok c.cameraToScreen.constructor.name is 'Transform', 'that is a Transform'
    ok c.screenToRaster?, 'and a property named "screenToRaster"'
    ok c.screenToRaster.constructor.name is 'Transform', 'that is a Transform:'
    r2sInverse = s2rMatrix = new Matrix4x4([[100,  0, 0, 100],
                                            [0, -100, 0, 100],
                                            [0,    0, 1,   0],
                                            [0,    0, 0,   1]])
    r2sMatrix = s2rInverse = new Matrix4x4([[0.01,  0, 0, -1],
                                            [0, -0.01, 0,  1],
                                            [0,     0, 1,  0],
                                            [0,     0, 0,  1]])
    for i in [0...c.screenToRaster.matrix.m.length]
      for j in [0...c.screenToRaster.matrix.m[i].length]
        equalWithin c.screenToRaster.matrix.m[i][j], s2rMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{s2rMatrix.m[i][j]}"
    for i in [0...c.screenToRaster.inverse.m.length]
      for j in [0...c.screenToRaster.inverse.m[i].length]
        equalWithin c.screenToRaster.inverse.m[i][j], s2rInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{s2rInverse.m[i][j]}"
    ok c.rasterToScreen?, 'and a property named "rasterToScreen"'
    ok c.rasterToScreen.constructor.name is 'Transform', 'that is a Transform:'
    for i in [0...c.rasterToScreen.matrix.m.length]
      for j in [0...c.rasterToScreen.matrix.m[i].length]
        equalWithin c.rasterToScreen.matrix.m[i][j], r2sMatrix.m[i][j], 15,
         "screenToRaster.matrix[#{i}][#{j}] should be #{r2sMatrix.m[i][j]}"
    for i in [0...c.rasterToScreen.inverse.m.length]
      for j in [0...c.rasterToScreen.inverse.m[i].length]
        equalWithin c.rasterToScreen.inverse.m[i][j], r2sInverse.m[i][j], 15,
         "screenToRaster.inverse[#{i}][#{j}] should be #{r2sInverse.m[i][j]}"
    ok c.rasterToCamera?, 'and a property named "rasterToCamera"'
    ok c.rasterToCamera.constructor.name is 'Transform', 'that is a Transform'
    ok c.dxCamera?, 'and a property named "dxCamera"'
    ok c.dxCamera.constructor.name is 'Vector', 'that is a Vector'
    ok c.dyCamera?, 'and a property named "dyCamera"'
    ok c.dyCamera.constructor.name is 'Vector', 'that is a Vector.'
    dxExpected = new Vector(0.0002, 0, 0)
    equalWithin c.dxCamera.x, dxExpected.x, 15, 'dxCamera.x is 0.0002,'
    equalWithin c.dxCamera.y, dxExpected.y, 15, 'dxCamera.y is 0 and'
    equalWithin c.dxCamera.z, dxExpected.z, 15, 'dxCamera.z is 0.'
    dyExpected = new Vector(0, -0.0002, 0)
    equalWithin c.dyCamera.x, dyExpected.x, 15, 'dyCamera.x is 0,'
    equalWithin c.dyCamera.y, dyExpected.y, 15, 'dyCamera.y is -0.0002 and'
    equalWithin c.dyCamera.z, dyExpected.z, 15, 'dyCamera.z is 0'
  
  module 'PerspectiveCamera - Prototype functions'

  test 'Test that all Prototype functions exist on a PerspectiveCamera:', ->
    expect 3
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    fov = 45
    near = 0.01
    far = 1000
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw, lr, fd)
    ok c?, 'If we create a PerspectiveCamera'
    ok c.generateRay?, 'it should have a "generateRay" function'
    ok c.generateRayDifferential?, 'and a "generateRayDifferential" function.'

  test 'Test that "generateRay" works correctly for PerspectiveCamera
        instances', ->
    expect 9
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    fov = 45
    near = 0.01
    far = 1000
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw, lr, fd)
    sample = imageX: 0, imageY: 0, time: 0
    ok sample?, 'If we create a mock sample object and pass it as an argument'
    ok c?, 'to the "generateRay" function of an PerspectiveCamera instance'
    [weight, ray] = c.generateRay sample
    ok weight?, 'a "weight" value should be returned'
    equal weight, 1, 'which should equal 1,'
    ok ray? and ray.constructor.name is 'Ray',
      'as well as a "ray" value that is a Ray.'
    dirExpected = new Vector(-2/3, 2/3, 1/3)
    equalWithin ray.direction.x, dirExpected.x, 15, 'direction.x is -2/3,'
    equalWithin ray.direction.y, dirExpected.y, 15, 'direction.y is 2/3 and'
    equalWithin ray.direction.z, dirExpected.z, 15, 'direction.z is 1/3.'
    equal ray.time, 0, 'ray.time should be equal to 0.'

  test 'Test that "generateRayDifferential" works correctly for
        PerspectiveCamera instances', ->
    expect 16
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    fov = 45
    near = 0.01
    far = 1000
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new PerspectiveCamera(c2w, so, sc, film, fov, near, far, sw, lr, fd)
    sample = imageX: 0, imageY: 0, time: 0
    ok sample?, 'If we create a mock sample object and pass it as an argument'
    ok c?, 'to the "generateRayDifferential" function of an PerspectiveCamera
            instance'
    [weight, rayDiff] = c.generateRayDifferential sample
    ok weight?, 'a "weight" value should be returned'
    equal weight, 1, 'which should equal 1,'
    ok rayDiff? and rayDiff.constructor.name is 'RayDifferential',
      'as well as a "rayDiff" value that is a RayDifferential.'
    dirExpected = new Vector(-2/3, 2/3, 1/3)
    equalWithin rayDiff.direction.x, dirExpected.x, 15, 'direction.x is -2/3,'
    equalWithin rayDiff.direction.y, dirExpected.y, 15, 'direction.y is 2/3 and'
    equalWithin rayDiff.direction.z, dirExpected.z, 15, 'direction.z is 1/3.'
    rayXdir = rayDiff.rayXDirection
    dirXEx = new Vector(-0.66293, 0.66963, 0.33481)
    rayYdir = rayDiff.rayYDirection
    dirYEx = new Vector(-0.66963, 0.66293, 0.33481)
    equalWithin rayXdir.x, dirXEx.x, 5,
      'rayDiff.rayXDirection.x is -0.66293,'
    equalWithin rayXdir.y, dirXEx.y, 5,
      'rayDiff.rayXDirection.y is 0.66963 and'
    equalWithin rayXdir.z, dirXEx.z, 5,
      'rayDiff.rayXDirection.z is 0.33481.'
    equalWithin rayYdir.x, dirYEx.x, 5,
      'rayDiff.rayYDirection.x is -0.66963,'
    equalWithin rayYdir.y, dirYEx.y, 5,
      'rayDiff.rayYDirection.y is 0.66293 and'
    equalWithin rayYdir.z, dirYEx.z, 5,
      'rayDiff.rayYDirection.z is 0.33481.'
    equal rayDiff.time, 0, 'rayDiff.time should be equal to 0,'
    ok rayDiff.hasDifferentials, 'rayDiff.hasDifferentials should be true.'