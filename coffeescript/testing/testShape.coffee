$(document).ready ->
  module 'Shape - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the required parameters of the Shape constructor:', ->
    expect 12
    ok Shape?, 'If we create a Shape by calling "new Shape" with no arguments'
    raises ->
        s = new Shape()
      , /objectToWorld must be defined./, 'a ShapeConstructorError is thrown: "objectToWorld must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, "If we pass a non-Transform object into the constructor as objectToWorld"
    raises ->
        s = new Shape(notTransform)
      , /objectToWorld must be a Transform./, 'a ShapeConstructorError is thrown: "objectToWorld must be a Transform."'
    o2w = new Transform()
    ok o2w?, 'If we create an objectToWorld transform and pass in into the constructor'
    raises ->
        s = new Shape(o2w)
      , /worldToObject must be defined./, 'a ShapeConstructorError is thrown: "worldToObject must be defined."'
    notTransform = 'NOT A TRANSFORM'
    ok notTransform?, 'If we pass a non-Transform object into the constructor as worldToObject'
    raises ->
        s = new Shape(o2w, notTransform)
      , /worldToObject must be a Transform./, 'a ShapeConstructorError is thrown: "worldToObject must be a Transform."'
    w2o = new Transform()
    ok w2o?, 'If we create an worldToObject transform and pass in into the constructor'
    raises ->
        s = new Shape(o2w, w2o)
      , /reverseOrientation must be defined./, 
      'an Error is thrown: "reverseOrientation must be defined."'
    notBoolean = 'NOT A BOOLEAN'
    ok notBoolean?, 'If we pass a non-Boolean object into the constructor as reverseOrientation'
    raises ->
        s = new Shape(o2w, w2o, notBoolean)
      , /reverseOrientation must be a Boolean./, 'a ShapeConstructorError is thrown: "reverseOrientation must be a Boolean."'
      
  test 'Test for Errors when passing incorrect values to the parameters of the Shape constructor that have default arguments:', ->
    expect 11
    o2w = new Transform()
    w2o = new Transform()
    s1 = new Shape(o2w, w2o, true)
    ok s1? and s1 instanceof Shape, 'If we create a Shape by calling "new Shape" with the correct arguments, the constructor should return a Shape'
    ok s1.objectToWorld? and s1.objectToWorld instanceof Transform, 'which has an "objectToWorld" property that is a Transform'
    ok s1.worldToObject? and s1.worldToObject instanceof Transform, 'and a "worldToObject" property that is a Transform'
    ok s1.reverseOrientation? and _.isBoolean(s1.reverseOrientation), "and a 'ReverseOrientation' property that is a Boolean"
    ok s1.transformSwapsHandedness? and _.isBoolean(s1.transformSwapsHandedness), 'and a "transformSwapsHandedness" property that is a Boolean'
    ok s1.shapeID? and _.isNumber(s1.shapeID), 'and a "ShapeID" property that is a number.'
    s2 = new Shape(o2w, w2o, true)
    s3 = new Shape(o2w, w2o, true)
    s4 = new Shape(o2w, w2o, true)
    ok s1? and s2? and s3? and s4?, 'If we create a whole bunch of Shapes,'
    equal s1.shapeID, s1.shapeID, 's1 should have a "shapeID" property of #{s1.ShapeID},'
    equal s2.shapeID, s1.shapeID + 1, 's2 should have a "shapeID" property of #{s1.ShapeID + 1},'
    equal s3.shapeID, s1.shapeID + 2, 's3 should have a "shapeID" property of #{s1.ShapeID + 2},'
    equal s4.shapeID, s1.shapeID + 3, 'and s4 should have a "shapeID" property of #{s1.ShapeID + 3}.'
  
  module 'Shape - Prototype functions'
  
  test 'Test that all Prototype functions exist on a Shape object:', ->
    expect 9
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, 'If we create a Shape'
    ok s.objectBound?, 'it should have an "objectBound" function,'
    ok s.worldBound?, 'and a "worldBound" function,'
    ok s.canIntersect?, 'and a "canIntersect" function,'
    ok s.refine?, 'and a "refine" function,'
    ok s.intersect?, 'and a "intersect" function,'
    ok s.intersectP?, 'and a "intersectP" function,'
    ok s.area?, 'and a "area" function,'
    ok s.getShadingGeometry?, 'and a "getShadingGeometry" function,'
  
  test 'Test for "MustBeOverriddenError" when calling "Shape.objectBound":', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, 'If we create a Shape, and call its "objectBound" function'
    raises ->
        s.objectBound()
      , /objectBound must be implemented by Shape subclasses./, 'a MustBeOverriddenError is thrown: "objectBound must be implemented by Shape subclasses."'
  
  test 'Test for "MustBeOverriddenError" when calling "Shape.worldBound":', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, "If we create a Shape, and call its 'worldBound' function"
    raises ->
        s.worldBound()
      , /objectBound must be implemented by Shape subclasses./, 'a MustBeOverriddenError is thrown: "objectBound must be implemented by Shape subclasses." This Error is thrown because although "Shape.worldBound" has a default implementation, it relies on a subclass specific "objectBound" implementation.'
  
  test 'Test that "Shape.canIntersect" works correctly for default Shape instance', ->
    expect 1
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s.canIntersect(), 'A default Shape instance should return "yes" for "Shape.canIntersect()"'
  
  test 'Test for "MustBeOverriddenError" when calling "Shape.refine"', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, "If we create a default Shape instance and call its 'refine' function"
    raises ->
        s.refine()
      , /refine must be implemented by Shape subclasses./, 'a MustBeOverriddenError is thrown: "refine must be implemented by Shape subclasses."'
  
  test 'Test for "Not MustBeOverriddenError"" when calling "Shape.intersect"', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, 'If we create a Shape, and call its "intersect" function'
    raises ->
        s.intersect()
      , /intersect must be implemented by Shape subclasses./, 'a MustBeOverriddenError is thrown: "intersect must be implemented by Shape subclasses."'
  
  test 'Test for "MustBeOverriddenError" when calling "Shape.intersectP"', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, 'If we create a Shape, and call its "intersectP" function'
    raises ->
        s.intersectP()
      , /intersectP must be implemented by Shape subclasses./, 'a MustBeOverriddenError is thrown: "intersectP must be implemented by Shape subclasses."'
  
  test 'Test for "MustBeOverriddenError" when calling "Shape.area"', ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok s?, 'If we create a Shape, and call its "area"function'
    raises ->
        s.area()
      , /area must be implemented by Shape subclasses./,  'a MustBeOverriddenError is thrown: "area must be implemented by Shape subclasses."'
  
  test 'Test that "Shape.getShadingGeometry" works correctly for default Shape instance', ->
    expect 9
    o2w = new Transform()
    w2o = new Transform()
    nullP = new Point(0, 0, 0)
    vU = new Vector(0, 0, 1)
    vV = new Vector(1, 0, 0)
    nU = new Normal(0, 0, 1)
    nV = new Normal(1, 0, 0)
    normNorm = new Normal(0, -1, 0)
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    dg = new DifferentialGeometry(nullP, vU, vV, nU, nV, 0.5, 0.5, s)
    ok s?, 'If we create a Shape, and call its "getShadingGeometry" function'
    sg = s.getShadingGeometry null, dg
    ok sg? and sg.constructor.name is 'DifferentialGeometry', 'it should return a "DifferentialGeometry"'
    ok Point.Equals(dg.point, sg.point), 'which should have the same "point" property as "dg"'
    ok Vector.Equals(dg.dpdu, sg.dpdu), 'and the same "dpdu" property as "dg"'
    ok Vector.Equals(dg.dpdv, sg.dpdv), 'and the same "dpdv" property as "dg"'
    ok Normal.Equals(dg.dndu, sg.dndu), 'and the same "dndu" property as "dg"'
    ok Normal.Equals(dg.dndv, sg.dndv), 'and the same "dndv" property as "dg"'
    equal dg.u, sg.u, 'and the same "u" property as "dg"'
    equal dg.v, sg.v, 'and the same "v" property as "dg".'