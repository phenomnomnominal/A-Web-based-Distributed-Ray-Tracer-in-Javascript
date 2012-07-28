$(document).ready ->
  module 'TriangleMesh - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the required parameters of the TriangleMesh constructor:', ->
    expect 28
    ok TriangleMesh?, 'If we create a TriangleMesh by calling "new TriangleMesh" with no arguments'
    raises ->
        tm = new TriangleMesh()
      , /objectToWorld must be defined./, 'a ShapeConstructorError is thrown: "objectToWorld must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, 'If we pass a non-Transform Object into the constructor as objectToWorld'
    raises ->
        tm = new TriangleMesh(notTransform)
      , /objectToWorld must be a Transform./, 'a ShapeConstructorError is thrown: "objectToWorld must be a Transform."'
    o2w = new Transform()
    ok o2w?, 'If we create an objectToWorld Transform and pass in into the constructor'
    raises ->
        tm = new TriangleMesh(o2w)
      ,/worldToObject must be defined./, 'a ShapeConstructorError is thrown: "worldToObject must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, 'If we pass a non-Transform Object into the constructor as worldToObject'
    raises ->
        tm = new TriangleMesh(o2w, notTransform)
      , /worldToObject must be a Transform./, 'a ShapeConstructorError is thrown: "worldToObject must be a Transform."'
    w2o = new Transform()
    ok w2o?, 'If we create an worldToObject Transform and pass in into the constructor'
    raises ->
        tm = new TriangleMesh(o2w, w2o)
      , /reverseOrientation must be defined./, 'a ShapeConstructorError is thrown: "reverseOrientation must be defined."'
    notBoolean = "NOT A BOOLEAN"
    ok notBoolean?, 'If we pass a non-Boolean Object into the constructor as reverseOrientation'
    raises ->
        tm new TriangleMesh(o2w, w2o, notBoolean)
      , /reverseOrientation must be a Boolean./, 'a ShapeConstructorError is thrown: "reverseOrientation must be a Boolean."'
    ro = true  
    ok ro?, 'If we create a reverseOrientation Boolean and pass it into the constructor'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro)
      , /numberTriangles must be defined./, 'a TriangleMeshConstructorError is thrown: "numberTriangles must be defined."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as numberTriangles'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, notNumber)
      , /numberTriangles must be a Number./, 'a TriangleMeshConstructorError is thrown: "numberTriangles must be a Number."'
    nt = 1
    ok nt?, 'If we create a numberTriangles Number and pass it into the constructor'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt)
      , /numberVertices must be defined./, 'a TriangleMeshConstructorError is thrown: "numberVertices must be defined."'
      notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as numberVertices'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, notNumber)
      , /numberVertices must be a Number./, 'a TriangleMeshConstructorError is thrown: "numberVertices must be a Number."'
    nv = 3
    ok nv?, 'If we create a numberVertices Number and pass it into the constructor'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv)
      , /vertexIndices must be defined./, 'a TriangleMeshConstructorError is thrown: "vertexIndices must be defined."'
    notArray = "NOT AN ARRAY"
    ok notArray?, 'If we pass a non-Array Object into the constructor as vertexIndices'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, notArray)
      , /vertexIndices must be an Array./, 'a TriangleMeshConstructorError is thrown: "vertexIndices must be an Array."'
    vi = [1, 2, 3]
    ok vi?, 'If we create a vertexIndices Array and pass it into the constructor'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi)
      , /positions must be defined./, 'a TriangleMeshConstructorError is thrown: "positions must be defined."'
      notArray = "NOT AN ARRAY"
    ok notArray?, 'If we pass a non-Array Object into the constructor as positions'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, notArray)
      , /positions must be an Array./, 'a TriangleMeshConstructorError is thrown: "positions must be an Array."'
    
  test 'Test for Errors when passing incorrect values to the parameters of the TriangleMesh constructor that have default arguments:', ->
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    p = [new Point(0, 0, 0), new Point(1, 0, 1), new Point(0, 1, 1)]
    notArray = "NOT AN ARRAY"
    ok notArray?, 'If we pass a non-Array Object into the constructor as normals'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, p, notArray)
      , /normals must be an Array./, 'a TriangleMeshConstructorError is thrown: "normals must be an Array"'
    notArray = "NOT AN ARRAY"
    ok notArray?, 'If we pass a non-Array Object into the constructor as tangents'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, p, [], notArray)
      , /tangents must be an Array./, 'a TriangleMeshConstructorError is thrown: "tangents must be an Array"'
    notArray = "NOT AN ARRAY"
    ok notArray?, 'If we pass a non-Array Object into the constructor as uvs'
    raises ->
        tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, p, [], [], notArray)
      , /uvs must be an Array./, 'a TriangleMeshConstructorError is thrown: "uvs must be an Array"'

    
  test 'Test creating a new TriangleMesh, supplying only the required arguments to the constructor:', ->
    expect 22
    ok TriangleMesh?, 'If we create a TriangleMesh by calling "new TriangleMesh" with the required arguments'
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    p = [new Point(0, 0, 0), new Point(1, 0, 1), new Point(0, 1, 1)]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, p)
    ok tm? and tm instanceof TriangleMesh, 'the constructor should return a TriangleMesh'
    ok tm.numberTriangles? and _.isNumber(tm.numberTriangles), 'which has a property named "numberTriangles" that is a Number'
    equal tm.numberTriangles, nt, 'that is equal to the argument "nt" (1)'
    ok tm.numberVertices? and _.isNumber(tm.numberVertices), 'and a property named "numberVertices" that is a Number'
    equal tm.numberVertices, nv, 'which is equal to the argument "nv" (3)'
    ok tm.vertexIndices? and _.isArray(tm.vertexIndices), 'and a property named "vertexIndices" that is an Array'
    equal tm.vertexIndices.length, 3, 'of length 3'
    equal tm.vertexIndices[0], 1, 'with values 1,'
    equal tm.vertexIndices[1], 2, '2'
    equal tm.vertexIndices[2], 3, 'and 3.'
    ok tm.positions? and _.isArray(tm.positions), 'It should also have a property name "positions" that is an Array'
    equal tm.positions.length, 3, 'of length 3'
    ok Point.Equals(tm.positions[0], new Point(0, 0, 0)), 'with values Point(0, 0, 0),'
    ok Point.Equals(tm.positions[1], new Point(1, 0, 1)), 'Point(1, 0, 1)'
    ok Point.Equals(tm.positions[2], new Point(0, 1, 1)), 'and Point(0, 1, 1).'
    ok tm.normals? and _.isArray(tm.normals), 'It should also have a property named "normals" that is an Array'
    equal tm.normals.length, 0, 'of length 0,'
    ok tm.tangents? and _.isArray(tm.tangents), 'and a property named "tangents" that is an Array'
    equal tm.tangents.length, 0, 'of length 0,'
    ok tm.uvs? and _.isArray(tm.uvs), 'and a property named "uvs" that is an Array'
    equal tm.uvs.length, 0, 'of length 0,'
    
  test 'Test that TriangleMesh data is actually copied, rather than stored as references:', ->
    expect 10
    ok TriangleMesh?, 'If we create a TriangleMesh by calling "new TriangleMesh" with the required arguments as well as non-default values for "normals", "tangesnts" and "uvs"'
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    p1 = new Point(0, 0, 0)
    p2 = new Point(1, 0, 0)
    p3 = new Point(0, 1, 0)
    p = [p1, p2, p3]
    n1 = new Normal(0, 0, 1)
    n = [n1, n1, n1]
    t1 = new Vector(1, 1, 0)
    t = [t1, t1, t1]
    uv1 = [0, 0]
    uv2 = [1, 0]
    uv3 = [1, 1]
    uvs = [uv1, uv2, uv3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, p, n, t, uvs)
    ok tm? and tm.constructor.name is 'TriangleMesh', 'the constructor should return a TriangleMesh.'
    ok tm.positions?, 'If any of the Points in the "positions" property are modified'
    tm.positions[0].x = 2
    equal p1.x, 0, 'the corresponding argument shouldn\'t be changed'
    ok tm.normals?, 'If any of the Normals in the "normals" property are modified'
    tm.normals[0].x = 2
    equal n1.x, 0, 'the corresponding argument shouldn\'t be changed'
    ok tm.tangents?, 'If any of the Vectors in the "tangents" property are modified'
    tm.tangents[0].x = 2
    equal t1.x, 1, 'the corresponding argument shouldn\'t be changed'
    ok tm.uvs?, 'If any of the UV values in the "uvs" property are modified'
    tm.uvs[0][0] = 1
    equal uv1[0], 0, 'the corresponding argument shouldn\'t be changed'
    
  module "TriangleMesh - Prototype functions"
  
  test "Test that all Prototype functions exist on a TriangleMesh:", ->
    expect 9
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, [new Point(0, 0, 0), new Point(1, 0, 0), new Point(0, 1, 0)])
    ok tm?, 'If we create a TriangleMesh'
    ok tm.objectBound?, 'it should have an "objectBound" function,'
    ok tm.worldBound?, 'and a "worldBound" function,'
    ok tm.canIntersect?, 'and a "canIntersect" function,'
    ok tm.refine?, 'and a "refine" function,'
    ok tm.intersect?, 'and a "intersect" function,'
    ok tm.intersectP?, 'and a "intersectP" function,'
    ok tm.area?, 'and a "area" function,'
    ok tm.getShadingGeometry?, 'and a "getShadingGeometry" function,'
    
  test 'Test that "objectBound" works correctly for a TriangleMesh instance:', ->
    expect 4
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, [new Point(3, 5, 0), new Point(-3, 0, -7), new Point(0, -5, 7)])
    ok tm?, 'If we create a TriangleMesh with Points at (3, 5, 0), (-3, 0, -7) and (0, -5, 7) and call the "objectBound" function,'
    bounds = tm.objectBound()
    ok bounds? and bounds instanceof BoundingBox, 'it should return a BoundingBox'
    ok Point.Equals(new Point(3, 5, 7), bounds.pMax), 'with pMax being a Point at (3, 5, 7)'
    ok Point.Equals(new Point(3, 5, 7), bounds.pMax), 'and pMin being a Point at (-3, -5, -7).'
    
  test 'Test that "worldBound" works correctly for a TriangleMesh instance:', ->
    expect 4
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, [new Point(3, 5, 0), new Point(-3, 0, -7), new Point(0, -5, 7)])
    ok tm?, 'If we create a TriangleMesh with Points at (3, 5, 0), (-3, 0, -7) and (0, -5, 7) and call the "worldBound" function,'
    bounds = tm.worldBound()
    ok bounds? and bounds instanceof BoundingBox, 'it should return a BoundingBox'
    ok Point.Equals(new Point(3, 5, 7), bounds.pMax), 'with pMax being a Point at (3, 5, 7)'
    ok Point.Equals(new Point(3, 5, 7), bounds.pMax), 'and pMin being a Point at (-3, -5, -7).'
    
  test 'Test that "canIntersect" works correctly for a TriangleMesh instance:', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, [new Point(0, 0, 0), new Point(1, 0, 0), new Point(0, 1, 0)])
    ok tm?, 'If we create a TriangleMesh and call the "canIntersect" function'
    equal tm.canIntersect(), no, 'it should return no.'
    
  test 'Test that "refine" works correctly for a TriangleMesh instance:', ->
    o2w = new Transform()
    w2o = new Transform()
    ro = true  
    nt = 1
    nv = 3
    vi = [1, 2, 3]
    tm = new TriangleMesh(o2w, w2o, ro, nt, nv, vi, [new Point(0, 0, 0), new Point(1, 0, 0), new Point(0, 1, 0)])
    ok tm?, 'If we create a TriangleMesh with one Triangle and call the "refine" function'
    triangles = tm.refine()
    ok _.isArray triangles, 'it should return an Array'
    equal triangles.length, 1, 'of length 1,'
    ok triangles[0] instanceof Triangle, 'which contains a Triangle.'