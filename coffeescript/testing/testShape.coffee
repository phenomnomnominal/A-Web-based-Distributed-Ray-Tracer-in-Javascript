$(document).ready(->
  module "Shape - constructor"
  
  test("Test creating a new Shape, supplying various arguments to the constructor", ->
    expect 21
    ok(Shape?, "If we create a Shape by calling 'new Shape' with no arguments,")
    raises(->
        s = new Shape()
        return
      , /ObjectToWorld must be defined./, 
      "an error is thrown: 'ObjectToWorld must be defined.'"
    )
    ok(Transform?, "If we pass a non-Transform object into the constructor as ObjectToWorld,")
    raises(->
        s = new Shape("NOT A TRANSFORM")
        return
      , /ObjectToWorld must be a Transform./, 
      "an error is thrown: 'ObjectToWorld must be a Transform.'"
    )
    ok(Transform?, "If we create an ObjectToWorld transform, and pass in into the constructor,")
    o2w = new Transform()
    raises(->
        s = new Shape(o2w)
        return
      , /WorldToObject must be defined./, 
      "an error is thrown: 'WorldToObject must be defined.'"
    )
    ok(Transform?, "If we pass a non-Transform object into the constructor as WorldToObject,")
    raises(->
        s = new Shape(o2w, "NOT A TRANSFORM")
        return
      , /WorldToObject must be a Transform./, 
      "an error is thrown: 'WorldToObject must be a Transform.'"
    )
    ok(Transform?, "If we create an WorldToObject transform, and pass in into the constructor,")
    w2o = new Transform()
    raises(->
        s = new Shape(o2w, w2o)
        return
      , /ReverseOrientation must be defined./, 
      "an error is thrown: 'ReverseOrientation must be defined.'"
    )
    s1 = new Shape(o2w, w2o, true)
    ok(s1? and s1.constructor.name is "Shape", "If we create a Shape by calling 'new Shape' with the correct arguments, the constructor should return a Shape")
    ok(s1.ObjectToWorld? and s1.ObjectToWorld.constructor.name is "Transform", "which has an 'ObjectToWorld' property that is a Transform")
    ok(s1.WorldToObject? and s1.WorldToObject.constructor.name is "Transform", "and a 'WorldToObject' property that is a Transform")
    ok(s1.ReverseOrientation? and s1.ReverseOrientation.constructor.name is "Boolean", "and a 'ReverseOrientation' property that is a Boolean")
    ok(s1.TransformSwapsHandedness? and s1.TransformSwapsHandedness.constructor.name is "Boolean", "and a 'TransformSwapsHandedness' property that is a Boolean")
    ok(s1.ShapeID? and s1.ShapeID.constructor.name is "Number", "and a 'ShapeID' property that is a number.")
    s2 = new Shape(o2w, w2o, true)
    s3 = new Shape(o2w, w2o, true)
    s4 = new Shape(o2w, w2o, true)
    ok(s1? and s2? and s3? and s4?, "If we create a whole bunch of Shapes,")
    equal(s1.ShapeID, s1.ShapeID, "s1 should have a 'ShapeID' property of #{s1.ShapeID},")
    equal(s2.ShapeID, s1.ShapeID + 1, "s2 should have a 'ShapeID' property of #{s1.ShapeID + 1},")
    equal(s3.ShapeID, s1.ShapeID + 2, "s3 should have a 'ShapeID' property of #{s1.ShapeID + 2},")
    equal(s4.ShapeID, s1.ShapeID + 3, "and s4 should have a 'ShapeID' property of #{s1.ShapeID + 3}.")
    return
  )
  
  module "Shape - Prototype functions"
  
  test("Test that all Prototype functions exist on a Shape object", ->
    expect 9
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape")
    ok(s.ObjectBound?, "it should have an 'ObjectBound' function,")
    ok(s.WorldBound?, "and a 'WorldBound' function,")
    ok(s.CanIntersect?, "and a 'CanIntersect' function,")
    ok(s.Refine?, "and a 'Refine' function,")
    ok(s.Intersect?, "and a 'Intersect' function,")
    ok(s.IntersectP?, "and a 'IntersectP' function,")
    ok(s.Area?, "and a 'Area' function,")
    ok(s.GetShadingGeometry?, "and a 'GetShadingGeometry' function,")
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.ObjectBound'", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape, and call its 'ObjectBound' function")
    raises(->
        s.ObjectBound()
        return
      , /Not Implemented - ObjectBound must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - ObjectBound must be implemented by Shape subclasses.'"
    )
    return
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.WorldBound'", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape, and call its 'WorldBound' function")
    raises(->
        s.WorldBound()
        return
      , /Not Implemented - ObjectBound must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - ObjectBound must be implemented by Shape subclasses.' This error is thrown because although Shape.WorldBound has a default implementation, it relies on a subclass specific ObjectBound implementation."
    )
    return
  )
  
  test("Test that 'Shape.CanIntersect' works correctly for default Shape instance", ->
    expect 1
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s.CanIntersect(), "A default Shape instance should return 'true' for Shape.CanIntersect()")
    return
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.Refine'.", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a default Shape instance and call its 'Refine' function")
    raises(->
        s.Refine()
        return
      , /Not Implemented - Refine must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - Refine must be implemented by Shape subclasses."
    )
    return
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.Intersect'", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape, and call its 'Intersect' function")
    raises(->
        s.Intersect()
        return
      , /Not Implemented - Intersect must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - Intersect must be implemented by Shape subclasses.'"
    )
    return
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.IntersectP'", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape, and call its 'IntersectP' function")
    raises(->
        s.IntersectP()
        return
      , /Not Implemented - IntersectP must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - IntersectP must be implemented by Shape subclasses.'"
    )
    return
  )
  
  test("Test for 'Not Implemented' error when calling 'Shape.Area'", ->
    expect 2
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    ok(s?, "If we create a Shape, and call its 'Area' function")
    raises(->
        s.Area()
        return
      , /Not Implemented - Area must be implemented by Shape subclasses./, 
      "an error is thrown: 'Not Implemented - Area must be implemented by Shape subclasses.'"
    )
    return
  )
  
  test("Test that 'Shape.GetShadingGeometry' works correctly for default Shape instance", ->
    expect 9
    o2w = new Transform()
    w2o = new Transform()
    nullP = new Point(0, 0, 0)
    vU = new Vector(0, 0, 1)
    vV = new Vector(1, 0, 0)
    normNorm = new Normal(0, -1, 0)
    o2w = new Transform()
    w2o = new Transform()
    s = new Shape(o2w, w2o, true)
    dg = new DifferentialGeometry(nullP, vU, vV, vU, vV, 0.5, 0.5, s)
    ok(s?, "If we create a Shape, and call its 'GetShadingGeometry' function")
    sg = s.GetShadingGeometry(null, dg)
    ok(sg? and sg.constructor.name is "DifferentialGeometry", "it should return a 'DifferentialGeometry'")
    ok(Point.Equals(dg.point, sg.point), "which should have the same 'point' property as 'dg'")
    ok(Vector.Equals(dg.dpdu, sg.dpdu), "and the same 'dpdu' property as 'dg'")
    ok(Vector.Equals(dg.dpdv, sg.dpdv), "and the same 'dpdv' property as 'dg'")
    ok(Vector.Equals(dg.dndu, sg.dndu), "and the same 'dndu' property as 'dg'")
    ok(Vector.Equals(dg.dndv, sg.dndv), "and the same 'dndv' property as 'dg'")
    equal(dg.u, sg.u, "and the same 'u' property as 'dg'")
    equal(dg.v, sg.v, "and the same 'v' property as 'dg'.")
  )
  return
)