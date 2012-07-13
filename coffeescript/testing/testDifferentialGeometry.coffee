$(document).ready(->
  
  module("DifferentialGeometry - constructor")
  
  test("Test creating a new DifferentialGeometry, supplying no arguments to the constructor", ->
    expect 5
    ok(DifferentialGeometry?,
      "If we create the default DifferentialGeometry by calling 'new DifferentialGeometry' with no arguments,")
    dg = new DifferentialGeometry
    ok(dg? and dg.constructor.name is "DifferentialGeometry", "the constructor should return a DifferentialGeometry")
    ok(dg.u? and dg.v?, "which has a 'u' property and a 'v' property.")
    equal(dg.u, 0, "The 'u' property should be equal to 0,")
    equal(dg.v, 0, "and the 'v' property should also be equal to 0.")
    return
  )
  
  test("Test creating a new DifferentialGeometry, supplying all required arguments to the constructor", ->
    expect 18
    ok(DifferentialGeometry?,
      "If we create a DifferentialGeometry by calling 'new DifferentialGeometry' with all required arguments,")
    nullP = new Point(0, 0, 0)
    vU = new Vector(0, 0, 1)
    vV = new Vector(1, 0, 0)
    normNorm = new Normal(0, -1, 0)
    o2w = new Transform()
    w2o = new Transform()
    dg = new DifferentialGeometry(nullP, vU, vV, vU, vV, 0.5, 0.5, new Shape(o2w, w2o, true))
    ok(dg? and dg.constructor.name is "DifferentialGeometry", "the constructor should return a DifferentialGeometry")
    ok(dg.point? and dg.point.constructor.name is "Point", "which has a 'point' property that is a Point,")
    ok(dg.dpdu? and dg.dpdu.constructor.name is "Vector", "and a 'dpdu' property that is a Vector,")
    ok(dg.dpdv? and dg.dpdv.constructor.name is "Vector", "and a 'dpdv' property that is a Vector,")
    ok(dg.dndu? and dg.dndu.constructor.name is "Vector", "and a 'dndu' property that is a Vector,")
    ok(dg.dndv? and dg.dndv.constructor.name is "Vector", "and a 'dndv' property that is a Vector,")    
    ok(dg.u? and dg.v?, "and has a 'u' property and a 'v' property,")
    ok(dg.normalisedNormal? and dg.normalisedNormal.constructor.name is "Normal", "and a 'normalisedNormal' property that is a Normal,")
    ok(dg.shape? and dg.shape.constructor.name is "Shape", "and a 'shape' property that is a Shape.")
    equal(dg.u, 0.5, "The 'u' property should be equal to 0.5,")
    equal(dg.v, 0.5, "and the 'v' property should also be equal to 0.5.")
    ok(Point.Equals(dg.point, nullP), "The 'point' property should be equal to the given point - (0, 0, 0).")
    ok(Vector.Equals(dg.dpdu, vU), "The 'dpdu' property should be equal to the given dpdu - (0, 0, 1).")
    ok(Vector.Equals(dg.dpdv, vV), "The 'dpdv' property should be equal to the given dpdv - (1, 0, 0).")
    ok(Vector.Equals(dg.dndu, vU), "The 'dndu' property should be equal to the given dndu - (0, 0, 1).")
    ok(Vector.Equals(dg.dndv, vV), "The 'dndv' property should be equal to the given dndv - (1, 0, 0).")
    ok(Normal.Equals(dg.normalisedNormal, normNorm), "The 'normalisedNormal' property should be equal to known Normal - (0, -1, 0).")
    return
  )

  return
)