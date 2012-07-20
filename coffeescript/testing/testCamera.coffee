$(document).ready ->
  module 'Camera - constructor:'
  
  test 'Test for Errors when passing incorrect arguments to the required parameters of the Camera constructor:', ->
    expect 20
    ok Camera?, 'If we create a Camera by calling "new Camera" with no arguments'
    raises ->
        c = new Camera()
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into the constructor as cameraToWorld'
    raises ->
        c = new Camera(notAnimatedTransform)
      , /Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it into the constructor'
    raises ->
        c = new Camera(c2w)
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as shutterOpen'
    raises ->
        c = new Camera(c2w, notNumber)
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be a Number."'
    so = 0
    ok so?, 'If we create a shutterOpen Number and pass it into the constructor'
    raises ->
        c = new Camera(c2w, so)
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as shutterClose'
    raises ->
        c = new Camera(c2w, so, notNumber)
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be a Number."'
    sc = 10
    ok sc?, 'If we create a shutterClose Number and pass it into the constructor'
    raises ->
        c = new Camera(c2w, so, sc)
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises ->
        c = new Camera(c2w, so, sc, notFilm)
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    ok film?, 'If we create a film Film and pass it into the constructor'
    c = new Camera(c2w, so, sc, film)
    ok c? and c.constructor.name is 'Camera', 'we will get a Camera Object.'
    scale = new AnimatedTransform(Transform.Scale(10, 10, 10), 0, Transform.Scale(10, 10, 10), 0)
    ok scale?, 'However, if we pass a AnimatedTransform with a scale factor into the construcotr'
    raises ->
        c = new Camera(scale, so, sc, film)
      , /Camera Constructor Error: cameraToWorld shouldn\'t have any scale factors in it./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld shouldn\'t have any scale factors in it."'
      
  test 'Test creating a new Camera, supplying valid arguments to the constructor:', ->
    expect 10
    ok Camera?, 'If we create a Camera by calling "new Camera" with a set of valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    ok c? and c.constructor.name is 'Camera', 'the constructor should return a Camera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform', 'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber c.shutterOpen, 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber c.shutterClose, 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film.'
    
  module 'Camera - Prototype functions:'
  
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
    
  test 'Test for "Not Implemented" Error when calling "generateRay" on a Camera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default Camera instance and call its "generateRay" function'
    raises ->
        c.generateRay()
      , /Not Implemented - generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented - generateRay must be implemented by Camera subclasses."'

  test 'Test for "Not Implemented" Error when calling "generateRayDifferential" on a Camera instance:', ->
    expect 2
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(1, 1)
    c = new Camera(c2w, so, sc, film)
    sample = "MOCK SAMPLE OBJECT"
    ok c?, 'If we create a default Camera instance and call its "generateRayDifferential" function'
    raises ->
        c.generateRayDifferential(sample)
      , /Not Implemented - generateRay must be implemented by Camera subclasses./,
      'an Error is thrown: "Not Implemented - generateRay must be implemented by Camera subclasses." This Error is thrown because  although "Camera.generateRayDifferential" has a default implementation, it relies on a subclass specific "generateRay" implementation.'
        
  module 'ProjectiveCamera - constructor:'
  
  test 'Test for Errors when passing incorrect arguments to the required parameters of the ProjectiveCamera constructor:', ->
    expect 34
    ok ProjectiveCamera?, 'If we create a ProjectiveCamera by calling "new ProjectiveCamera" with no arguments'
    raises ->
        c = new ProjectiveCamera()
      , /Camera Constructor Error: cameraToWorld must be defined./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be defined."'
    notAnimatedTransform = 'NOT AN ANIMATEDTRANSFORM'
    ok notAnimatedTransform?, 'If we pass a non-AnimatedTransform Object into the constructor as cameraToWorld'
    raises ->
        c = new ProjectiveCamera(notAnimatedTransform)
      , /Camera Constructor Error: cameraToWorld must be an AnimatedTransform./,
      'an Error is thrown: "Camera Constructor Error: cameraToWorld must be an AnimatedTransform."'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    ok c2w?, 'If we create a cameraToWorld AnimatedTransform and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w)
      , /Camera Constructor Error: shutterOpen must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as shutterOpen'
    raises ->
        c = new ProjectiveCamera(c2w, notNumber)
      , /Camera Constructor Error: shutterOpen must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterOpen must be a Number."'
    so = 0
    ok so?, 'If we create a shutterOpen Number and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so)
      , /Camera Constructor Error: shutterClose must be defined./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as shutterClose'
    raises ->
        c = new ProjectiveCamera(c2w, so, notNumber)
      , /Camera Constructor Error: shutterClose must be a Number./,
      'an Error is thrown: "Camera Constructor Error: shutterClose must be a Number."'
    sc = 10
    ok sc?, 'If we create a shutterClose Number and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc)
      , /Camera Constructor Error: film must be defined./,
      'an Error is thrown: "Camera Constructor Error: film must be defined."'
    notFilm = 'NOT A FILM'
    ok notFilm?, 'If we pass a non-Film Object into the constructor as film'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, notFilm)
      , /Camera Constructor Error: film must be a Film./,
      'an Error is thrown: "Camera Constructor Error: film must be a Film."'
    film = new Film(1, 1)
    ok film?, 'If we create a film Film and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film)
      , /ProjectiveCamera Constructor Error: projectiveTransform must be defined./, 
      'an Error is thrown: "ProjectiveCamera Constructor Error: projectiveTransform must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, 'If we pass a non-Transform Object into the constructor as projectiveTransform'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, notTransform)
      , /ProjectiveCamera Constructor Error: projectiveTransform must be a Transform./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: projectiveTransform must be a Transform."'
    pt = Transform.Orthographic(0, 100)
    ok pt?, 'If we create a projectiveTransform Transform and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt)
      , /ProjectiveCamera Constructor Error: screenWindow must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow must be defined."' 
    notArray = 'NOT AN ARRAY'
    ok notArray?, 'If we pass a non-Array Object into the constructor as screenWindow'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt, notArray)
      , /ProjectiveCamera Constructor Error: screenWindow must be an Array./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: screenWindow must be an Array."'
    sw = [-1, 1, -1, 1]
    ok sw?, 'If we create a screenWindow Array and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt, sw)
      , /ProjectiveCamera Constructor Error: lensRadius must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as lensRadius'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, notNumber)
      , /ProjectiveCamera Constructor Error: lensRadius must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: lensRadius must be a Number."'
    lr = 1
    ok lr?, 'If we create a lensRadius Number and pass it into the constructor'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr)
      , /ProjectiveCamera Constructor Error: focalDistance must be defined./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as focalDistance'
    raises ->
        c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, notNumber)
      , /ProjectiveCamera Constructor Error: focalDistance must be a Number./,
      'an Error is thrown: "ProjectiveCamera Constructor Error: focalDistance must be a Number."'
    fd = 2
    ok fd?, 'If we create a focalDistance Number and pass it into the constructor'
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    ok c? and c.constructor.name is 'ProjectiveCamera', 'we will get a Camera Object.'
    
  test 'Test creating a new ProjectiveCamera, supplying valid arguments to the constructor:', ->
    expect 12
    ok ProjectiveCamera?, 'If we create a ProjectiveCamera by calling "new ProjectiveCamera" with a set of valid arguments'
    c2w = new AnimatedTransform(new Transform(), 0, new Transform(), 0)
    so = 0
    sc = 1
    film = new Film(200, 200)
    pt = Transform.Orthographic(0, 100)
    sw = [-1, 1, -1, 1]
    lr = 1
    fd = 2
    c = new ProjectiveCamera(c2w, so, sc, film, pt, sw, lr, fd)
    ok c? and c.constructor.name is 'ProjectiveCamera', 'the constructor should return a ProjectiveCamera'
    ok c.cameraToWorld?, 'which has a property named "cameraToWorld"'
    ok c.cameraToWorld.constructor.name is 'AnimatedTransform', 'that is an AnimatedTransform'
    ok c.shutterOpen?, 'and a property named "shutterOpen"'
    ok _.isNumber(c.shutterOpen), 'that is a Number'
    ok c.shutterClose?, 'and a property named "shutterClose"'
    ok _.isNumber(c.shutterClose), 'that is a Number'
    ok c.film?, 'and a property named "film"'
    ok c.film.constructor.name is 'Film', 'that is a Film'
    ok c.cameraToScreen?, 'and a property named "cameraToScreen"'
    ok c.cameraToScreen.constructor.name is 'Transform', 'that is a Transform'
    