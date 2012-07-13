$(document).ready(->

  module "Transform"
  
  test("Test creating a new Transform, supplying no arguments to the constructor", ->
    expect 6
    ok(Transform?, 
      "If we create the default Transform by calling 'new Transform' with no arguments,")
    t = new Transform
    ok(t? and t.constructor.name is "Transform", "the constructor should return a Transform")
    ok(t.matrix? and t.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(t.inverse? and t.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    ok(Matrix4x4.IsIdentity(t.matrix), "The matrix property is expected to be an Identity matrix")
    ok(Matrix4x4.IsIdentity(t.inverse), "and the inverse property is expected to be an Identity matrix")
  )
  
  test("Test creating a new Transform, supplying only the matrix to the constructor", ->
    expect 21
    m = new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]])
    inv = new Matrix4x4([[-0.04,0,-0.08,0.36],[0.34,0,0.18,-0.06],[-0.108,0.2,-0.116,-0.028],[0.12,0,0.24,-0.08]])
    ok(m? and inv? and m.constructor.name is "Matrix4x4" and inv.constructor.name is "Matrix4x4",
      "If we start with a known transformation matrix and its known inverse, and create a new Transform from only the matrix,")
    t = new Transform(m)
    ok(t? and t.constructor.name is "Transform", "the constructor should return a Transform")
    ok(t.matrix? and t.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(t.inverse? and t.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    ok(Matrix4x4.Equals(t.matrix, m), "The matrix property is expected to be equal to the original known matrix,")
    for i in [0..3]
      for j in [0..3]
        equalWithin(t.inverse.m[i][j], inv.m[i][j], 15, "inverse[#{i}][#{j}] is expected to be equal to inv[#{i}][#{j}],")
    return
  )
  
  test("Test creating a new Transform, supplying only the inverse to the constructor", ->
    expect 21
    m = new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]])
    inv = new Matrix4x4([[-0.04,0,-0.08,0.36],[0.34,0,0.18,-0.06],[-0.108,0.2,-0.116,-0.028],[0.12,0,0.24,-0.08]])
    ok(m? and inv? and m.constructor.name is "Matrix4x4" and inv.constructor.name is "Matrix4x4",
      "If we start with a known transformation matrix and its known inverse, and create a new Transform from only the inverse,")
    t = new Transform(null, inv)
    ok(t? and t.constructor.name is "Transform", "the constructor should return a Transform")
    ok(t.matrix? and t.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(t.inverse? and t.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    for i in [0..3]
      for j in [0..3]
        equalWithin(t.inverse.m[i][j], inv.m[i][j], 15, "matrix[#{i}][#{j}] is expected to be equal to m[#{i}][#{j}],")
    ok(Matrix4x4.Equals(t.inverse, inv), "and the inverse property is expected to be equal to original known inverse")
    return
  )
  
  test("Test creating the inverse of a Transform using Transform.InverseTransform", ->
    expect 9
    m = new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]])
    inv = new Matrix4x4([[-0.04,0,-0.08,0.36],[0.34,0,0.18,-0.06],[-0.108,0.2,-0.116,-0.028],[0.12,0,0.24,-0.08]])
    ok(m? and inv? and m.constructor.name is "Matrix4x4" and inv.constructor.name is "Matrix4x4",
      "If we start with a known transformation matrix and its known inverse, and create a new Transform instance from them,")
    t = new Transform(m, inv)
    ok(t? and t.constructor.name is "Transform", "the constructor should return a Transform")
    ok(t.matrix? and t.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(t.inverse? and t.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    invT = Transform.InverseTransform(t)
    ok(invT? and invT.constructor.name is "Transform", 
      "If we create an InverseTransform for the Transform, the function should return a Transform")
    ok(invT.matrix? and invT.matrix.constructor.name is "Matrix4x4", "which alse has a matrix property that is a Matrix4x4")
    ok(invT.inverse? and invT.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    ok(Matrix4x4.Equals(invT.matrix, inv), "The matrix property of the Inverse should be the inverse property of the original,")  
    ok(Matrix4x4.Equals(invT.inverse, m), "and the inverse property of the Inverse should be the matrix property of the original.")
    return
  )
  
  test("Test Transform equality using Transform.Equals", ->
    expect 2
    t1 = new Transform(new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]]))
    t2 = new Transform(new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]]))
    ok(t1? and t2? and t1.constructor.name is "Transform" and t2.constructor.name is "Transform",
      "If we create two identical Transforms by calling the constructor with the same arguments,")
    ok(Transform.Equals(t1, t2), "calling 'Transform.Equals' with the two Transforms as arguments should return true.")
    return
  )
  
  test("Test Transform equality using the 'equals' function of a Transform instance.", ->
    expect 3
    t1 = new Transform(new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]]))
    t2 = new Transform(new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]]))
    ok(t1? and t2? and t1.constructor.name is "Transform" and t2.constructor.name is "Transform",
      "If we create two identical Transforms by calling the constructor with the same arguments,")
    ok(t1.equals(t2), "calling 'equals' on the first with the second as the argument should return true.")
    ok(t2.equals(t1), "Calling 'equals' on the second with the first as the argument should also return true.")
    return
  )
  
  test("Test if a Transform is an Identity Transfrom using Transform.IsIdentity.", ->
    expect 5
    ok(Transform?, 
      "If we create the default Transform by calling 'new Transform' with no arguments,")
    t = new Transform
    ok(t? and t.constructor.name is "Transform", "the constructor should return a Transform")
    ok(t.matrix? and t.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(t.inverse? and t.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    ok(Transform.IsIdentity(t), "Calling 'IsIdentity' on the Transform is expected to return true.")  
  )
  
  test("Test creating a new Translation Transform using Transform.Translate.", ->
    expect 36
    ok(Transform.Translate?, 
      "If we try to create a Transform which Translates by Vector(3, 2, 1),")
    translate = Transform.Translate(new Vector(3, 2, 1))
    ok(translate? and translate.constructor.name is "Transform", "the function should return a Transform")
    ok(translate.matrix? and translate.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(translate.inverse? and translate.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    translateM = new Matrix4x4([[1, 0, 0, 3],
                                [0, 1, 0, 2],
                                [0, 0, 1, 1],
                                [0, 0, 0, 1]])
    translateI = new Matrix4x4([[1, 0, 0, -3],
                                [0, 1, 0, -2],
                                [0, 0, 1, -1],
                                [0, 0, 0, 1]])
    for i in [0...translate.matrix.m.length]
      for j in [0...translate.matrix.m[i].length]
        equalWithin(translate.matrix.m[i][j], translateM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{translateM.m[i][j]}")
    for i in [0...translate.inverse.m.length]
      for j in [0...translate.inverse.m[i].length]
        equalWithin(translate.inverse.m[i][j], translateI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{translateM.m[i][j]}")
    return
  )
  
  test("Test creating a new Scaling Transform using Transform.Scale.", ->
    expect 36
    ok(Transform.Scale?, 
      "If we try to create a Transform which Scales by 3, 2 and 1 in the X, Y and Z directions respectively,")
    scale = Transform.Scale(3, 2, 1)
    ok(scale? and scale.constructor.name is "Transform", "the function should return a Transform")
    ok(scale.matrix? and scale.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(scale.inverse? and scale.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    scaleM = new Matrix4x4([[3, 0, 0, 0],
                            [0, 2, 0, 0],
                            [0, 0, 1, 0],
                            [0, 0, 0, 1]])
    scaleI = new Matrix4x4([[1/3, 0,   0, 0],
                            [0,   1/2, 0, 0],
                            [0,   0,   1, 0],
                            [0,   0,   0, 1]])
    for i in [0...scale.matrix.m.length]
      for j in [0...scale.matrix.m[i].length]
        equalWithin(scale.matrix.m[i][j], scaleM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{scaleM.m[i][j]}")
    for i in [0...scale.inverse.m.length]
      for j in [0...scale.inverse.m[i].length]
        equalWithin(scale.inverse.m[i][j], scaleI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{scaleM.m[i][j]}")
    return
  )
  
  test("Test creating a new X Axis Rotation Transform using Transform.RotateX.", ->
    expect 36
    ok(Transform.RotateX?, 
      "If we try to create a Transform which Rotates around the X Axis by 90 degrees,")
    rotateX = Transform.RotateX(90)
    ok(rotateX? and rotateX.constructor.name is "Transform", "the function should return a Transform")
    ok(rotateX.matrix? and rotateX.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(rotateX.inverse? and rotateX.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    rotateXM = new Matrix4x4([[1, 0,  0, 0],
                              [0, 0, -1, 0],
                              [0, 1,  0, 0],
                              [0, 0,  0, 1]])
    rotateXI = new Matrix4x4([[1,  0, 0, 0],
                              [0,  0, 1, 0],
                              [0, -1, 0, 0],
                              [0,  0, 0, 1]])
    for i in [0...rotateX.matrix.m.length]
      for j in [0...rotateX.matrix.m[i].length]
        equalWithin(rotateX.matrix.m[i][j], rotateXM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{rotateXM.m[i][j]}")
    for i in [0...rotateX.inverse.m.length]
      for j in [0...rotateX.inverse.m[i].length]
        equalWithin(rotateX.inverse.m[i][j], rotateXI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{rotateXI.m[i][j]}")
    return
  )
  
  test("Test creating a new Y Axis Rotation Transform using Transform.RotateY.", ->
    expect 36
    ok(Transform.RotateY?, 
      "If we try to create a Transform which Rotates around the Y Axis by 90 degrees,")
    rotateY = Transform.RotateY(90)
    ok(rotateY? and rotateY.constructor.name is "Transform", "the function should return a Transform")
    ok(rotateY.matrix? and rotateY.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(rotateY.inverse? and rotateY.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    rotateYM = new Matrix4x4([[ 0, 0, 1, 0],
                              [ 0, 1, 0, 0],
                              [-1, 0, 0, 0],
                              [ 0, 0, 0, 1]])
    rotateYI = new Matrix4x4([[0, 0, -1, 0],
                              [0, 1,  0, 0],
                              [1, 0,  0, 0],
                              [0, 0,  0, 1]])
    for i in [0...rotateY.matrix.m.length]
      for j in [0...rotateY.matrix.m[i].length]
        equalWithin(rotateY.matrix.m[i][j], rotateYM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{rotateYM.m[i][j]}")
    for i in [0...rotateY.inverse.m.length]
      for j in [0...rotateY.inverse.m[i].length]
        equalWithin(rotateY.inverse.m[i][j], rotateYI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{rotateYI.m[i][j]}")
    return
  )
  
  test("Test creating a new Z Axis Rotation Transform using Transform.RotateZ.", ->
    expect 36
    ok(Transform.RotateZ?, 
      "If we try to create a Transform which Rotates around the Z Axis by 90 degrees,")
    rotateZ = Transform.RotateZ(90)
    ok(rotateZ? and rotateZ.constructor.name is "Transform", "the function should return a Transform")
    ok(rotateZ.matrix? and rotateZ.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(rotateZ.inverse? and rotateZ.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    rotateZM = new Matrix4x4([[0, -1, 0, 0],
                              [1,  0,  0, 0],
                              [0,  0,  1, 0],
                              [0,  0,  0, 1]])
    rotateZI = new Matrix4x4([[ 0, 1, 0, 0],
                              [-1, 0, 0, 0],
                              [ 0, 0, 1, 0],
                              [ 0, 0, 0, 1]])
    for i in [0...rotateZ.matrix.m.length]
      for j in [0...rotateZ.matrix.m[i].length]
        equalWithin(rotateZ.matrix.m[i][j], rotateZM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{rotateZM.m[i][j]}")
    for i in [0...rotateZ.inverse.m.length]
      for j in [0...rotateZ.inverse.m[i].length]
        equalWithin(rotateZ.inverse.m[i][j], rotateZI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{rotateZI.m[i][j]}")
    return
  )
  
  test("Test creating a new Arbitrary Axis Rotation Transform using Transform.RotateZ.", ->
    expect 36
    ok(Transform.Rotate?, 
      "If we try to create a Transform which Rotates around an arbitrary Axis - Vector(0,0,1) - by 90 degrees,")
    rotate = Transform.Rotate(90, new Vector(0, 0, 1))
    ok(rotate? and rotate.constructor.name is "Transform", "the function should return a Transform")
    ok(rotate.matrix? and rotate.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(rotate.inverse? and rotate.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    rotateM = new Matrix4x4([[0, -1, 0, 0],
                              [1,  0,  0, 0],
                              [0,  0,  1, 0],
                              [0,  0,  0, 1]])
    rotateI = new Matrix4x4([[ 0, 1, 0, 0],
                              [-1, 0, 0, 0],
                              [ 0, 0, 1, 0],
                              [ 0, 0, 0, 1]])
    for i in [0...rotate.matrix.m.length]
      for j in [0...rotate.matrix.m[i].length]
        equalWithin(rotate.matrix.m[i][j], rotateM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{rotateM.m[i][j]}")
    for i in [0...rotate.inverse.m.length]
      for j in [0...rotate.inverse.m[i].length]
        equalWithin(rotate.inverse.m[i][j], rotateI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{rotateI.m[i][j]}")
    return
  )
  
  test("Test transforming a Point using Transform.TransformPoint.", ->
    expect 7
    point = new Point(0, 0, 3)
    ok(point? and point.constructor.name is "Point", "If we have a Point with (x,y,z) = (0,0,3)")
    rotateX = Transform.RotateX(90)
    ok(rotateX? and rotateX.constructor.name is "Transform", "and a Transform which Rotates around the X Axis by 90 degrees,")
    point = Transform.TransformPoint(rotateX, point)
    ok(point? and point.constructor.name is "Point", "The transformation should return a Point")
    ok(point.x? and point.y? and point.z?, "with x, y and z properties.")
    equalWithin(point.x, 0, 15, "x should be unchanged (0),")
    equalWithin(point.y, -3, 15, "y should be -3")
    equalWithin(point.z, 0, 15, "and z should be 0.")
    return
  )
  test("Test transforming a Vector using Transform.TransformVector.", ->
    expect 7
    vector = new Vector(0, 3, 3)
    ok(vector? and vector.constructor.name is "Vector", "If we have a Vector with (x,y,z) = (0,3,3)")
    rotateZ = Transform.RotateZ(90)
    ok(rotateZ? and rotateZ.constructor.name is "Transform", "and a Transform which Rotates around the Z Axis by 90 degrees,")
    vector = Transform.TransformVector(rotateZ, vector)
    ok(vector? and vector.constructor.name is "Vector", "The transformation should return a Vector")
    ok(vector.x? and vector.y? and vector.z?, "with x, y and z properties.")
    equalWithin(vector.x, -3, 15, "x should be -3,")
    equalWithin(vector.y, 0, 15, "y should be 0")
    equalWithin(vector.z, 3, 15, "and z should be unchanged (3).")
    return
  )
  
  test("Test transforming a Normal using Transform.TransformNormal.", ->
    expect 7
    normal = new Normal(2, 2, 2)
    ok(normal? and normal.constructor.name is "Normal", "If we have a Normal with (x,y,z) = (2,2,2)")
    rotateY = Transform.RotateY(180)
    ok(rotateY? and rotateY.constructor.name is "Transform", "and a Transform which Rotates around the Y Axis by 180 degrees,")
    normal = Transform.TransformNormal(rotateY, normal)
    ok(normal? and normal.constructor.name is "Normal", "The transformation should return a Normal")
    ok(normal.x? and normal.y? and normal.z?, "with x, y and z properties.")
    equalWithin(normal.x, -2, 15, "x should be -2,")
    equalWithin(normal.y, 2, 15, "y should be unchanged (2)")
    equalWithin(normal.z, -2, 15, "and z should be -2.")
    return
  )
  
  test("Test transforming a Ray using Transform.TransformRay.", ->
    expect 11
    ray = new Ray(new Point(3, 4, 5), new Vector(0, 5, 6), 0)
    ok(ray? and ray.constructor.name is "Ray", "If we have a Ray with origin = Point(3,4,5) and direction = Vector(0,5,6)")
    scale = Transform.Scale(2, 2, 2)
    ok(scale? and scale.constructor.name is "Transform", "and a Transform which Scales in all directions by 2,")
    ray = Transform.TransformRay(scale, ray)
    ok(ray? and ray.constructor.name is "Ray", "applying the transformation to the Ray should return a Ray")
    ok(ray.origin? and ray.origin.constructor.name is "Point", "which has an origin property that is a Point,")
    ok(ray.direction? and ray.direction.constructor.name is "Vector", "and a direction property that is a Vector.")
    equalWithin(ray.origin.x, 6, 15, "origin.x should be 6,")
    equalWithin(ray.origin.y, 8, 15, "origin.y should be 8,")
    equalWithin(ray.origin.z, 10, 15, "and origin.z should be 10.")
    equalWithin(ray.direction.x, 0, 15, "direction.x should be 0,")
    equalWithin(ray.direction.y, 10, 15, "origin.y should be 10,")
    equalWithin(ray.direction.z, 12, 15, "and origin.z should be 12.")
  )
  
  test("Test transforming a RayDifferential using Transform.TransformRayDifferential.", ->
    throw Error "TODO: Not yet implemented"
  )
  
  test("Test transforming a BoundingBox using Transform.TransformBoundingBox.", ->
    expect 11
    bbox = new BoundingBox(new Point(0,0,0), new Point(3,3,3))
    ok(bbox? and bbox.constructor.name is "BoundingBox", "If we have a BoundingBox with pMin = Point(0,0,0) and pMax = Point(3,3,3)")
    rotateY = Transform.RotateY(135)
    ok(rotateY? and rotateY.constructor.name is "Transform", "and a Transform which Rotates around the Y Axis by 135 degrees,")
    bbox = Transform.TransformBoundingBox(rotateY, bbox)
    ok(bbox? and bbox.constructor.name is "BoundingBox", "applying the transformation to the BoundingBox should return a BoundingBox")
    ok(bbox.pMin? and bbox.pMin.constructor.name is "Point", "which has a pMin property that is a Point,")
    ok(bbox.pMax? and bbox.pMax.constructor.name is "Point", "and a pMin property that is also a Point.")
    equalWithin(bbox.pMin.x, -Math.sqrt(4.5), 15, "pMin.x should be equal to -sqrt(4.5),")
    equalWithin(bbox.pMin.y, 0, 15, "pMin.y should be equal to 0")
    equalWithin(bbox.pMin.z, -2*Math.sqrt(4.5), 15, "and pMin.z should be equal to -2*sqrt(4.5).")    
    equalWithin(bbox.pMax.x, Math.sqrt(4.5), 15, "pMax.x should be equal to sqrt(4.5),")
    equalWithin(bbox.pMax.y, 3, 15, "pMax.y should be equal to 3")
    equalWithin(bbox.pMax.z, 0, 15, "and pMax.z should be equal to 0")
    return
  )
  
  test("Test create composite transformations using Transform.Multiply", ->
    expect 37
    translate = Transform.Translate(new Vector(3, 2, 1))
    ok(translate? and translate.constructor.name is "Transform", 
      "If we create a Transform which Translates by Vector(3, 2, 1),")
    rotateX = Transform.RotateX(90)
    ok(rotateX? and rotateX.constructor.name is "Transform", 
      "and a Transform which Rotates around the X Axis by 90 degrees,")
    composite = Transform.Multiply(translate, rotateX)
    ok(composite? and composite.constructor.name is "Transform",
      "the 'Transform.Multiply' function should return a Transform")
    ok(composite.matrix? and composite.matrix.constructor.name is "Matrix4x4", "which has a matrix property that is a Matrix4x4")
    ok(composite.inverse? and composite.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    compositeM = new Matrix4x4([[1, 0,  0, 3],
                                [0, 0, -1, 2],
                                [0, 1,  0, 1],
                                [0, 0,  0, 1]])
    compositeI = new Matrix4x4([[1,  0, 0, -3],
                                [0,  0, 1, -1],
                                [0, -1, 0,  2],
                                [0,  0, 0,  1]])
    for i in [0...composite.matrix.m.length]
      for j in [0...composite.matrix.m[i].length]
        equalWithin(composite.matrix.m[i][j], compositeM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{compositeM.m[i][j]}")
    for i in [0...composite.inverse.m.length]
      for j in [0...composite.inverse.m[i].length]
        equalWithin(composite.inverse.m[i][j], compositeI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{compositeI.m[i][j]}")
    return
  )
  
  test("Test checking for Transforms that swap a coordinate systems handedness using Transform.SwapHandedness.", ->
    expect 4
    scaleSH = Transform.Scale(1, 1, -1)
    ok(scaleSH? and scaleSH.constructor.name is "Transform", 
      "If we create a Transform which Scales by -1 in the Z direction,")
    ok(Transform.SwapsHandedness(scaleSH), "we should have a Transform that swaps the handedness of the coordinate system.")
    scale = Transform.Scale(2, 2, 2)
    ok(scale? and scale.constructor.name is "Transform", 
      "If we create a Transform which Scales by 2 in all directions however,")
    ok(!Transform.SwapsHandedness(scale), "we should have a Transform that doesn't swap the handedness of the coordinate system.")
    return
  )
  
  test("Test checking for Transforms that have a scaling factor using the 'hasScale' function of a Transform instance.", ->
    expect 4
    scale = Transform.Scale(2, 2, 2)
    ok(scale? and scale.constructor.name is "Transform", 
      "If we create a Transform which Scales by 2 in all directions,")
    ok(scale.hasScale(), "we should have a Transform that has a scaling factor.")
    rotate = Transform.RotateX(90)
    ok(rotate? and rotate.constructor.name is "Transform", 
      "If we create a Transform which shouldn't involve any scaling, e.g. a RotateX,")
    ok(!rotate.hasScale(), "we should have a Transform that doesn't have a scaling factor.")
    return
  )
  
  test("Test creating a new Orthographic Projection Transform using Transform.Orthographic.", ->
    expect 37
    ok(Transform.Orthographic?, 
      "If we try to create a Transform which orthographically projects from a 3D view onto a 2D image plane,")
    orthographic = Transform.Orthographic(0.1, 100)
    ok(orthographic? and orthographic.constructor.name is "Transform", "the function should return a Transform")
    ok(orthographic.hasScale(), "which should have a scaling factor,")
    ok(orthographic.matrix? and orthographic.matrix.constructor.name is "Matrix4x4", "and also has a matrix property that is a Matrix4x4")
    ok(orthographic.inverse? and orthographic.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    a = 1 / (100 - 0.1)
    b = (100 - 0.1)
    orthographicM = new Matrix4x4([[1, 0, 0,  0],
                                   [0, 1, 0,  0],
                                   [0, 0, a, -a/10],
                                   [0, 0, 0,  1]])
    orthographicI = new Matrix4x4([[1, 0, 0, 0],
                                   [0, 1, 0, 0],
                                   [0, 0, b, 0.1],
                                   [0, 0, 0, 1]])
    for i in [0...orthographic.matrix.m.length]
      for j in [0...orthographic.matrix.m[i].length]
        equalWithin(orthographic.matrix.m[i][j], orthographicM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{orthographicM.m[i][j]}")
    for i in [0...orthographic.inverse.m.length]
      for j in [0...orthographic.inverse.m[i].length]
        equalWithin(orthographic.inverse.m[i][j], orthographicI.m[i][j], 15, "inverse[#{i}][#{j}] should be #{orthographicI.m[i][j]}")
    return
  )
  
  test("Test creating a new Perspective Projection Transform using Transform.Perspective.", ->
    expect 37
    ok(Transform.Perspective?, 
      "If we try to create a Transform which perspectively projects from a 3D view onto a 2D image plane,")
    perspective = Transform.Perspective(45, 0.1, 100)
    ok(perspective? and perspective.constructor.name is "Transform", "the function should return a Transform")
    ok(perspective.hasScale(), "which should have a scaling factor,")
    ok(perspective.matrix? and perspective.matrix.constructor.name is "Matrix4x4", "and also has a matrix property that is a Matrix4x4")
    ok(perspective.inverse? and perspective.inverse.constructor.name is "Matrix4x4", "and an inverse property that is a Matrix4x4.")
    a = 100 / (100 - 0.1)
    b = -100 * 0.1 / (100 - 0.1)
    perspectiveM = new Matrix4x4([[0.5, 0, 0, 0],
                                  [0, 0.5, 0, 0],
                                  [0, 0, a, b],
                                  [0, 0, 1, 0]])
    perspectiveI = new Matrix4x4([[2, 0, 0, 0],
                                  [0, 2, 0, 0],
                                  [0, 0, 0, 1],
                                  [0, 0, -9.99, 10]])
    for i in [0...perspective.matrix.m.length]
      for j in [0...perspective.matrix.m[i].length]
        equalWithin(perspective.matrix.m[i][j], perspectiveM.m[i][j], 15, "matrix[#{i}][#{j}] should be #{perspectiveM.m[i][j]}")
    for i in [0...perspective.inverse.m.length]
      for j in [0...perspective.inverse.m[i].length]
        # Annoyingly, need to use a precision of 14 here, silly rounding errors.
        equalWithin(perspective.inverse.m[i][j], perspectiveI.m[i][j], 14, "inverse[#{i}][#{j}] should be #{perspectiveI.m[i][j]}")
    return
  )
)