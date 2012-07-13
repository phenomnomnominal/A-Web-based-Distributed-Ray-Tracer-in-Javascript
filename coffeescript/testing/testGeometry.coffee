$(document).ready(->
  
  module("Vector")
  
  test("New Vector with defaults", ->
    v = new Vector()
    equal(v.x, 0, "v.x is expected to be equal to 0")
    equal(v.y, 0, "v.y is expected to be equal to 0")
    equal(v.z, 0, "v.z is expected to be equal to 0")
    return
  )
  
  test("New Vector", ->
    v = new Vector(0, 1, 2)
    equal(v.x, 0, "v.x is expected to be equal to 0")
    equal(v.y, 1, "v.y is expected to be equal to 1")
    equal(v.z, 2, "v.z is expected to be equal to 2")
    return
  )
   
  test("New Vector with NaNs", ->
    raises(->
        v = new Vector(0, 1, NaN)
        return
      , /Vector contains a NaN/, "Throws Error - Vector contains a NaN")
    return
  )
  
  test("New Vector from Normal", ->
    v = new Vector.FromNormal(new Normal(0, 1, 2))
    equal(v.x, 0, "v.x is expected to be equal to 0")
    equal(v.y, 1, "v.y is expected to be equal to 1")
    equal(v.z, 2, "v.z is expected to be equal to 2")
    return
  )
   
  test("New Vector from Point", ->
    v = new Vector.FromPoint(new Point(0, 1, 2))
    equal(v.x, 0, "v.x is expected to be equal to 0")
    equal(v.y, 1, "v.y is expected to be equal to 1")
    equal(v.z, 2, "v.z is expected to be equal to 2")
    return
  )
  
  test("New Vector from Vector", ->
    v = new Vector.FromVector(new Vector(0, 1, 2))
    equal(v.x, 0, "v.x is expected to be equal to 0")
    equal(v.y, 1, "v.y is expected to be equal to 1")
    equal(v.z, 2, "v.z is expected to be equal to 2")
    return
  )
    
  test("Add Vectors with static function", ->
    v = Vector.Add(new Vector(0, 1, 2), new Vector(1, 2, 3))
    equal(v.x, 1, "v.x is expected to be equal to 1")
    equal(v.y, 3, "v.y is expected to be equal to 3")
    equal(v.z, 5, "v.z is expected to be equal to 5")
    return
  )
  
  test("Add Vectors with instance function", ->
    v = new Vector(0, 1, 2)
    v.add(new Vector(1, 2, 3))
    equal(v.x, 1, "v.x is expected to be equal to 1")
    equal(v.y, 3, "v.y is expected to be equal to 3")
    equal(v.z, 5, "v.z is expected to be equal to 5")
    return
  )
  
  test("Subtract Vectors with static function", ->
    v = Vector.Subtract(new Vector(0, 1, 2), new Vector(1, 2, 3))
    equal(v.x, -1, "v.x is expected to be equal to -1")
    equal(v.y, -1, "v.y is expected to be equal to -1")
    equal(v.z, -1, "v.z is expected to be equal to -1")
    return
  )
  
  test("Subtract Vectors with instance function", ->
    v = new Vector(0, 1, 2)
    v.subtract(new Vector(1, 2, 3))
    equal(v.x, -1, "v.x is expected to be equal to -1")
    equal(v.y, -1, "v.y is expected to be equal to -1")
    equal(v.z, -1, "v.z is expected to be equal to -1")
    return
  )
  
  test("Multiply Vector with static function", ->
    v = Vector.Multiply(new Vector(1, 2, 3), 3)
    equal(v.x, 3, "v.x is expected to be equal to 3")
    equal(v.y, 6, "v.y is expected to be equal to 6")
    equal(v.z, 9, "v.z is expected to be equal to 9")
    return
  )
  
  test("Multiply Vector with instance function", ->
    v = new Vector(1, 2, 3)
    v.multiply(3)
    equal(v.x, 3, "v.x is expected to be equal to 3")
    equal(v.y, 6, "v.y is expected to be equal to 6")
    equal(v.z, 9, "v.z is expected to be equal to 9")
    return
  )
  
  test("Divide Vector with static function", ->
    v = Vector.Divide(new Vector(1, 2, 3), 3)
    equal(v.x, 1/3, "v.x is expected to be equal to 1/3")
    equal(v.y, 2/3, "v.y is expected to be equal to 2/3")
    equal(v.z, 1, "v.z is expected to be equal to 1")
    return
  )
  
  test("Divide Vector with static function, wrong argument", ->
    raises(->
      v = Vector.Divide(new Vector(1, 2, 3), 0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Vector by 0")
    return
  )
  
  test("Divide Vector with instance function", ->
    v = new Vector(1, 2, 3)
    v.divide(3)
    equal(v.x, 1/3, "v.x is expected to be equal to 1/3")
    equal(v.y, 2/3, "v.y is expected to be equal to 2/3")
    equal(v.z, 1, "v.z is expected to be equal to 1")
    return
  )
  
  test("Divide Vector with instance function, wrong argument", ->
    raises(->
      v = new Vector(1, 2, 3)
      v.divide(0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Vector by 0")
    return
  )
  
  test("Negate Vector with instance function", ->
    vn = Vector.Negate(new Vector(1, 2, 3))
    equal(vn.x, -1, "vn.x is expected to be equal to -1")
    equal(vn.y, -2, "vn.y is expected to be equal to -2")
    equal(vn.z, -3, "vn.z is expected to be equal to -3")
    return
  )
  
  test("Convert a Vector to an Array", ->
    a = new Vector(1, 2, 3).toArray()
    equal(a[0], 1, "a[0] is expected to be equal to 1")
    equal(a[1], 2, "a[1] is expected to be equal to 2")
    equal(a[2], 3, "a[2] is expected to be equal to 3")
    return
  )
  
  test("Vector Equals with static function", ->
    v1 = new Vector(-1, 2, -3)
    v2 = new Vector(-1, 2, -3)
    n3 = new Normal(-1, 2, -3)
    equal(Vector.Equals(v1, v2), true, "v1 is expected to be equal to v2")
    equal(Vector.Equals(v1, n3), false, "v1 is expected to not be equal to n3")
    return
  )
  
  test("Vector Equals with instance function", ->
    v1 = new Vector(-1, 2, -3)
    v2 = new Vector(-1, 2, -3)
    n3 = new Normal(-1, 2, -3)
    equal(v1.equals(v2), true, "v1 is expected to be equal to v2")
    equal(v1.equals(n3), false, "v1 is expected to not be equal to n3")
    return
  )
  
  test("Calculate the Dot product of two Vectors with static function", ->
    dot1 = Vector.Dot(new Vector(1, 3, -5), new Vector(4, -2, -1))
    dot2 = Vector.Dot(new Normal(-6, 3, 0), new Vector(2, 8, 8))
    dot3 = Vector.Dot(new Vector(2, 6, 1), new Normal(0, 1, -2))
    equal(dot1, 3, "dot is expected to be equal to 3")
    equal(dot2, 12, "dot is expected to be equal to 12")
    equal(dot3, 4, "dot is expected to be equal to 4")
    return
  )
  
  test("Calculate the Absolute Value of the Dot product of two Vectors with static function", ->
    absdot1 = Vector.AbsDot(new Vector(-1, -3, -5), new Vector(4, 2, 1))
    absdot2 = Vector.AbsDot(new Normal(-6, 3, 0), new Vector(2, -8, 8))
    absdot3 = Vector.AbsDot(new Vector(2, 6, 1), new Normal(0, 1, -2))
    equal(absdot1, 15, "absdot is expected to be equal to 15")
    equal(absdot2, 36, "absdot is expected to be equal to 36")
    equal(absdot3, 4, "absdot is expected to be equal to 4")
    return
  )
  
  test("Calculate the Cross product of two Vectors with static function", ->
    crossVV = Vector.Cross(new Vector(2, 5, 1), new Vector(-3, 2, 4))
    equal(crossVV.x, 18, "crossVV.x is expected to be equal to 18")
    equal(crossVV.y, -11, "crossVV.y is expected to be equal to -11")
    equal(crossVV.z, 19, "crossVV.z is expected to be equal to 19")
    crossNV = Vector.Cross(new Normal(2, 5, 1), new Vector(-3, 2, 4))
    equal(crossNV.x, 18, "crossNV.x is expected to be equal to 18")
    equal(crossNV.y, -11, "crossNV.y is expected to be equal to -11")
    equal(crossNV.z, 19, "crossNV.z is expected to be equal to 19")
    crossVN = Vector.Cross(new Vector(2, 5, 1), new Normal(-3, 2, 4))
    equal(crossVN.x, 18, "crossVN.x is expected to be equal to 18")
    equal(crossVN.y, -11, "crossVN.y is expected to be equal to -11")
    equal(crossVN.z, 19, "crossVN.z is expected to be equal to 19")
    return
  )
  
  test("Normalise a Vector with static function", ->
    normalise = Vector.Normalise(new Vector(1, 2, 3))
    equal(normalise.x, 0.2672612419124244, "normalise.x is expected to be equal to 0.2672612419124244")
    equal(normalise.y, 0.5345224838248488, "normalise.y is expected to be equal to 0.5345224838248488")
    equal(normalise.z, 0.8017837257372732, "normalise.z is expected to be equal to 0.8017837257372732")
    return
  )
  
  test("Generate Coordinate System from Vector", ->
    [v1, v2, v3] = Vector.CoordinateSystem(new Vector(1, 0, 0))
    ok(v1.equals(new Vector(1, 0, 0)))
    ok(v2.equals(new Vector(0, 0, 1)))
    ok(v3.equals(new Vector(0, -1, 0)))
    return
  )
  
  module("Point")
  
  test("New Point with defaults", ->
    p = new Point()
    equal(p.x, 0, "p.x is expected to be equal to 0")
    equal(p.y, 0, "p.y is expected to be equal to 0")
    equal(p.z, 0, "p.z is expected to be equal to 0")
    return
  )
  
  test("New Point", ->
    p = new Point(0, 1, 2)
    equal(p.x, 0, "p.x is expected to be equal to 0")
    equal(p.y, 1, "p.y is expected to be equal to 1")
    equal(p.z, 2, "p.z is expected to be equal to 2")
    return
  )
   
  test("New Point with NaNs", ->
    raises(->
        v = new Point(0, 1, NaN)
        return
      , /Point contains a NaN/, "Throws Error - Point contains a NaN")
    return
  )
  
  test("New Point from Point", ->
    p = new Point.FromPoint(new Point(0, 1, 2))
    equal(p.x, 0, "p.x is expected to be equal to 0")
    equal(p.y, 1, "p.y is expected to be equal to 1")
    equal(p.z, 2, "p.z is expected to be equal to 2")
    return
  )
  
  test("Add Points with static function", ->
    p = Point.AddPointToPoint(new Point(0, 1, 2), new Point(1, 2, 3))
    equal(p.x, 1, "p.x is expected to be equal to 1")
    equal(p.y, 3, "p.y is expected to be equal to 3")
    equal(p.z, 5, "p.z is expected to be equal to 5")
    return
  )
  
  test("Add Vector to Point with static function", ->
    p = Point.AddVectorToPoint(new Point(0, 1, 2), new Vector(1, 2, 3))
    equal(p.x, 1, "p.x is expected to be equal to 1")
    equal(p.y, 3, "p.y is expected to be equal to 3")
    equal(p.z, 5, "p.z is expected to be equal to 5")
    return
  )
  
  test("Add Point to Point with instance function", ->
    p = new Point(0, 1, 2)
    p.addPoint(new Point(1, 2, 3))
    equal(p.x, 1, "v.x is expected to be equal to 1")
    equal(p.y, 3, "v.y is expected to be equal to 3")
    equal(p.z, 5, "v.z is expected to be equal to 5")
    return
  )
  
  test("Add Vector to Point with instance function", ->
    p = new Point(0, 1, 2)
    p.addVector(new Vector(1, 2, 3))
    equal(p.x, 1, "p.x is expected to be equal to 1")
    equal(p.y, 3, "p.y is expected to be equal to 3")
    equal(p.z, 5, "p.z is expected to be equal to 5")
    return
  )
  
  test("Subtract Points with static function", ->
    p = Point.SubtractPointFromPoint(new Point(0, 1, 2), new Point(1, 2, 3))
    equal(p.x, -1, "p.x is expected to be equal to -1")
    equal(p.y, -1, "p.y is expected to be equal to -1")
    equal(p.z, -1, "p.z is expected to be equal to -1")
    return
  )
  
  test("Subtract Vector from Point with static function", ->
    p = Point.SubtractVectorFromPoint(new Point(0, 1, 2), new Vector(1, 2, 3))
    equal(p.x, -1, "p.x is expected to be equal to -1")
    equal(p.y, -1, "p.y is expected to be equal to -1")
    equal(p.z, -1, "p.z is expected to be equal to -1")
    return
  )
  
  test("Subtract Vector from Point with instance function", ->
    p = new Point(0, 1, 2)
    p.subtractVector(new Vector(1, 2, 3))
    equal(p.x, -1, "p.x is expected to be equal to -1")
    equal(p.y, -1, "p.y is expected to be equal to -1")
    equal(p.z, -1, "p.z is expected to be equal to -1")
    return
  )
  
  test("Multiply Points with static function", ->
    p = Point.Multiply(new Point(2, 3, 4), 2)
    equal(p.x, 4, "p.x is expected to be equal to 4")
    equal(p.y, 6, "p.y is expected to be equal to 6")
    equal(p.z, 8, "p.z is expected to be equal to 8")
    return
  )
  
  test("Multiply Point with instance function", ->
    p = new Point(1, 2, 3)
    p.multiply(3)
    equal(p.x, 3, "v.x is expected to be equal to 3")
    equal(p.y, 6, "v.y is expected to be equal to 6")
    equal(p.z, 9, "v.z is expected to be equal to 9")
    return
  )
  
  test("Divide Point with static function", ->
    p = new Point(1, 2, 3)
    p = Point.Divide(p, 3)
    equal(p.x, 1/3, "p.x is expected to be equal to 1/3")
    equal(p.y, 2/3, "p.y is expected to be equal to 2/3")
    equal(p.z, 1, "p.z is expected to be equal to 1")
    return
  )
  
  test("Divide Point with static function, wrong argument", ->
    raises(->
      p = new Point(1, 2, 3)
      p = Point.Divide(p, 0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Point by 0")
    return
  )
  
  test("Divide Point with instance function", ->
    p = new Point(1, 2, 3)
    p.divide(3)
    equal(p.x, 1/3, "p.x is expected to be equal to 1/3")
    equal(p.y, 2/3, "p.y is expected to be equal to 2/3")
    equal(p.z, 1, "p.z is expected to be equal to 1")
    return
  )
  
  test("Divide Point with static function, wrong argument", ->
    raises(->
      p = new Point(1, 2, 3)
      p.divide(0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Point by 0")
    return
  )
  
  test("Convert a Point to an Array", ->
    p = new Point(1, 2, 3)
    a = p.toArray()
    equal(a[0], 1, "a[0] is expected to be equal to 1")
    equal(a[1], 2, "a[1] is expected to be equal to 2")
    equal(a[2], 3, "a[2] is expected to be equal to 3")
  )
  
  test("Point Equals with static function", ->
    p1 = new Point(-1, 2, -3)
    p2 = new Point(-1, 2, -3)
    n3 = new Normal(-1, 2, -3)
    equal(Point.Equals(p1, p2), true, "p1 is expected to be equal to p2")
    equal(Point.Equals(p1, n3), false, "p1 is expected to not be equal to n3")
    return
  )
  
  test("Point Equals with instance function", ->
    p1 = new Point(-1, 2, -3)
    p2 = new Point(-1, 2, -3)
    n3 = new Normal(-1, 2, -3)
    equal(p1.equals(p2), true, "p1 is expected to be equal to p2")
    equal(p1.equals(n3), false, "p1 is expected to not be equal to n3")
    return
  )
  
  test("Point Distance with static function", ->
    p1 = new Point(0, 0, 0)
    p2 = new Point(3, 4, 0)
    equal(Point.Distance(p1, p2), 5, "Distance from p1 to p2 is expected to be equal to 5")
    return
  )
  
  test("Point DistanceSquared with static function", ->
    p1 = new Point(0, 0, 0)
    p2 = new Point(3, 4, 5)
    equal(Point.DistanceSquared(p1, p2), 50, "Distance from p1 to p2 squared is expected to be equal to 50")
    return
  )
  
  module("Normal")
  
  test("New Normal with defaults", ->
    n = new Normal()
    equal(n.x, 0, "n.x is expected to be equal to 0")
    equal(n.y, 0, "n.y is expected to be equal to 0")
    equal(n.z, 0, "n.z is expected to be equal to 0")
    return
  )
  
  test("New Normal", ->
    n = new Normal(0, 1, 2)
    equal(n.x, 0, "n.x is expected to be equal to 0")
    equal(n.y, 1, "n.y is expected to be equal to 1")
    equal(n.z, 2, "n.z is expected to be equal to 2")
    return
  )
   
  test("New Normal with NaNs", ->
    raises(->
        n = new Normal(0, 1, NaN)
        return
      , /Normal contains a NaN/, "Throws Error - Normal contains a NaN")
    return
  )
  
  test("New Normal from Normal", ->
    n = new Normal.FromNormal(new Normal(0, 1, 2))
    equal(n.x, 0, "n.x is expected to be equal to 0")
    equal(n.y, 1, "n.y is expected to be equal to 1")
    equal(n.z, 2, "n.z is expected to be equal to 2")
    return
  )
   
  test("New Normal from Vector", ->
    n = new Normal.FromVector(new Vector(0, 1, 2))
    equal(n.x, 0, "n.x is expected to be equal to 0")
    equal(n.y, 1, "n.y is expected to be equal to 1")
    equal(n.z, 2, "n.z is expected to be equal to 2")
    return
  )
    
  test("Add Normals with static function", ->
    n = Normal.Add(new Normal(0, 1, 2), new Normal(1, 2, 3))
    equal(n.x, 1, "n.x is expected to be equal to 1")
    equal(n.y, 3, "n.y is expected to be equal to 3")
    equal(n.z, 5, "n.z is expected to be equal to 5")
    return
  )
  
  test("Add Normals with instance function", ->
    n = new Normal(0, 1, 2)
    n.add(new Normal(1, 2, 3))
    equal(n.x, 1, "n.x is expected to be equal to 1")
    equal(n.y, 3, "n.y is expected to be equal to 3")
    equal(n.z, 5, "n.z is expected to be equal to 5")
    return
  )
  
  test("Subtract Normals with static function", ->
    n = Normal.Subtract(new Normal(0, 1, 2), new Normal(1, 2, 3))
    equal(n.x, -1, "n.x is expected to be equal to -1")
    equal(n.y, -1, "n.y is expected to be equal to -1")
    equal(n.z, -1, "n.z is expected to be equal to -1")
    return
  )
  
  test("Subtract Normals with instance function", ->
    n = new Normal(0, 1, 2)
    n.subtract(new Normal(1, 2, 3))
    equal(n.x, -1, "n.x is expected to be equal to -1")
    equal(n.y, -1, "n.y is expected to be equal to -1")
    equal(n.z, -1, "n.z is expected to be equal to -1")
    return
  )
  
  test("Multiply Normal with static function", ->
    n = Normal.Multiply(new Normal(1, 2, 3), 3)
    equal(n.x, 3, "n.x is expected to be equal to 3")
    equal(n.y, 6, "n.y is expected to be equal to 6")
    equal(n.z, 9, "n.z is expected to be equal to 9")
    return
  )
  
  test("Multiply Normal with instance function", ->
    n = new Normal(1, 2, 3)
    n.multiply(3)
    equal(n.x, 3, "n.x is expected to be equal to 3")
    equal(n.y, 6, "n.y is expected to be equal to 6")
    equal(n.z, 9, "n.z is expected to be equal to 9")
    return
  )
  
  test("Divide Normal with static function", ->
    n = Normal.Divide(new Normal(1, 2, 3), 3)
    equal(n.x, 1/3, "n.x is expected to be equal to 1/3")
    equal(n.y, 2/3, "n.y is expected to be equal to 2/3")
    equal(n.z, 1, "n.z is expected to be equal to 1")
    return
  )
  
  test("Divide Normal with static function, wrong argument", ->
    raises(->
      v = Normal.Divide(new Normal(1, 2, 3), 0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Normal by 0")
    return
  )
  
  test("Divide Normal with instance function", ->
    n = new Normal(1, 2, 3)
    n.divide(3)
    equal(n.x, 1/3, "n.x is expected to be equal to 1/3")
    equal(n.y, 2/3, "n.y is expected to be equal to 2/3")
    equal(n.z, 1, "n.z is expected to be equal to 1")
    return
  )
  
  test("Divide Normal with instance function, wrong argument", ->
    raises(->
      n = new Normal(1, 2, 3)
      n.divide(0)
      return
    , /Scale value is 0/, "Throws Error - Trying to divide a Normal by 0")
    return
  )
  
  test("Negate Normal with instance function", ->
    nn = Normal.Negate(new Normal(1, 2, 3))
    equal(nn.x, -1, "nn.x is expected to be equal to -1")
    equal(nn.y, -2, "nn.y is expected to be equal to -2")
    equal(nn.z, -3, "nn.z is expected to be equal to -3")
    return
  )
  
  test("Convert a Normal to an Array", ->
    a = new Normal(1, 2, 3).toArray()
    equal(a[0], 1, "a[0] is expected to be equal to 1")
    equal(a[1], 2, "a[1] is expected to be equal to 2")
    equal(a[2], 3, "a[2] is expected to be equal to 3")
    return
  )
  
  test("Normal Equals with static function", ->
    n1 = new Normal(-1, 2, -3)
    n2 = new Normal(-1, 2, -3)
    v3 = new Vector(-1, 2, -3)
    equal(Normal.Equals(n1, n2), true, "n1 is expected to be equal to n2")
    equal(Normal.Equals(n1, v3), false, "n1 is expected to not be equal to v3")
    return
  )
  
  test("Normal Equals with instance function", ->
    n1 = new Normal(-1, 2, -3)
    n2 = new Normal(-1, 2, -3)
    v3 = new Vector(-1, 2, -3)
    equal(n1.equals(n2), true, "n1 is expected to be equal to n2")
    equal(n1.equals(v3), false, "n1 is expected to not be equal to v3")
    return
  )
  
  test("Calculate the Dot product of two Normals with static function", ->
    dot1 = Normal.Dot(new Normal(1, 3, -5), new Normal(4, -2, -1))
    dot2 = Normal.Dot(new Normal(-6, 3, 0), new Vector(2, 8, 8))
    dot3 = Normal.Dot(new Vector(2, 6, 1), new Normal(0, 1, -2))
    equal(dot1, 3, "dot is expected to be equal to 3")
    equal(dot2, 12, "dot is expected to be equal to 12")
    equal(dot3, 4, "dot is expected to be equal to 4")
    return
  )
  
  test("Calculate the Absolute Value of the Dot product of two Normals with static function", ->
    absdot1 = Normal.AbsDot(new Normal(-1, -3, -5), new Normal(4, 2, 1))
    absdot2 = Normal.AbsDot(new Normal(-6, 3, 0), new Vector(2, -8, 8))
    absdot3 = Normal.AbsDot(new Vector(2, 6, 1), new Normal(0, 1, -2))
    equal(absdot1, 15, "absdot is expected to be equal to 15")
    equal(absdot2, 36, "absdot is expected to be equal to 36")
    equal(absdot3, 4, "absdot is expected to be equal to 4")
    return
  )
  
  test("Normalise a Normal with static function", ->
    normalise = Normal.Normalise(new Normal(1, 2, 3))
    equal(normalise.x, 0.2672612419124244, "normalise.x is expected to be equal to 0.2672612419124244")
    equal(normalise.y, 0.5345224838248488, "normalise.y is expected to be equal to 0.5345224838248488")
    equal(normalise.z, 0.8017837257372732, "normalise.z is expected to be equal to 0.8017837257372732")
    return
  )
  
  test("FaceForward Normal with static function", ->
    ff = Normal.FaceForward(new Normal(1, 3, -5), new Normal(4, -2, -1))
    equal(ff.x, 1, "ff.x is expected to be equal to 1")
    equal(ff.y, 3, "ff.y is expected to be equal to 3")
    equal(ff.z, -5, "ff.z is expected to be equal to -5")
    ff = Normal.FaceForward(new Normal(-3, 3, -5), new Normal(4, -2, 1))
    equal(ff.x, 3, "ff.x is expected to be equal to 3")
    equal(ff.y, -3, "ff.y is expected to be equal to -3")
    equal(ff.z, 5, "ff.z is expected to be equal to 5")
  )
  
  module("Ray")
  
  test("New Ray, no parent", ->
    origin = new Point(0,0,0)
    direction = new Vector(2, 2, 2)
    raises(->
      ray = new Ray(origin, direction)
      return  
    , /If origin and direction and specified, then minTime must be as well./, "Throws Error - minTime not specified")
    ray = new Ray(origin, direction, 1)
    equal(ray.origin.x, 0, "ray.origin.x is expected to be equal to 0")
    equal(ray.origin.y, 0, "ray.origin.y is expected to be equal to 0")
    equal(ray.origin.z, 0, "ray.origin.z is expected to be equal to 0")
    equal(ray.direction.x, 2, "ray.direction.x is expected to be equal to 2")
    equal(ray.direction.y, 2, "ray.direction.y is expected to be equal to 2")
    equal(ray.direction.z, 2, "ray.direction.z is expected to be equal to 2")
    equal(ray.minTime, 1, "ray.minTime is expected to be 1")
    equal(ray.parent, null, "ray.parent is expected to be null")
    equal(ray.maxTime, Infinity, "ray.maxTime is expected to be Infinity")
    equal(ray.time, 0, "ray.time is expected to be 0")
    equal(ray.depth, 0, "ray.depth is expected to be 0")
    return
  )
  
  test("New Ray, from parent ray", ->
    origin = new Point(0,0,0)
    direction = new Vector(2, 2, 2)
    parent = new Ray(origin, direction, 1, null, Infinity, 5, 0)
    childOrigin = new Point(2, 2, 2)
    childDirection = new Vector(-2, 2, 2)
    ray = new Ray(childOrigin, childDirection, 1, parent)
    equal(ray.origin.x, 2, "ray.origin.x is expected to be equal to 2")
    equal(ray.origin.y, 2, "ray.origin.y is expected to be equal to 2")
    equal(ray.origin.z, 2, "ray.origin.z is expected to be equal to 2")
    equal(ray.direction.x, -2, "ray.direction.x is expected to be equal to -2")
    equal(ray.direction.y, 2, "ray.direction.y is expected to be equal to 2")
    equal(ray.direction.z, 2, "ray.direction.z is expected to be equal to 2")
    equal(ray.minTime, 1, "ray.minTime is expected to be 1")
    equal(ray.maxTime, Infinity, "ray.maxTime is expected to be Infinity")
    equal(ray.time, 5, "ray.time is expected to be 5")
    equal(ray.depth, 1, "ray.depth is expected to be 1")
    return
  )
  
  test("Ray getPoint with instance function", ->
    origin = new Point(0,0,0)
    direction = new Vector(2, 3, 4)
    ray = new Ray(origin, direction, 1)
    p = ray.getPoint(3)
    equal(p.x, 6, "p.x is expected to be equal to 6")
    equal(p.y, 9, "p.y is expected to be equal to 9")
    equal(p.z, 12, "p.z is expected to be equal to 12")
    return
  )
  
  module("RayDifferential")
  
  test("New RayDifferential", ->
    rayDiff = new RayDifferential(new Point(0,0,0), new Vector(2, 2, 2), 1)
    equal(rayDiff.origin.x, 0, "rayDiff.origin.x is expected to be equal to 0")
    equal(rayDiff.origin.y, 0, "rayDiff.origin.y is expected to be equal to 0")
    equal(rayDiff.origin.z, 0, "rayDiff.origin.z is expected to be equal to 0")
    equal(rayDiff.direction.x, 2, "rayDiff.direction.x is expected to be equal to 2")
    equal(rayDiff.direction.y, 2, "rayDiff.direction.y is expected to be equal to 2")
    equal(rayDiff.direction.z, 2, "rayDiff.direction.z is expected to be equal to 2")
    equal(rayDiff.parent, null, "rayDiff.parent is expected to be null")
    equal(rayDiff.minTime, 1, "rayDiff.minTime is expected to be 1")
    equal(rayDiff.maxTime, Infinity, "rayDiff.maxTime is expected to be Infinity")
    equal(rayDiff.time, 0, "rayDiff.time is expected to be 0")
    equal(rayDiff.depth, 0, "rayDiff.depth is expected to be 0")
    equal(rayDiff.hasDifferentials, false, "rayDiff.hasDifferentials is expected to be false")
    equal(rayDiff.rayXOrigin, null, "rayDiff.rayXOrigin is expected to be null")
    equal(rayDiff.rayYOrigin, null, "rayDiff.rayYOrigin is expected to be null")
    equal(rayDiff.rayXDirection, null, "rayDiff.rayXDirection is expected to be null")
    equal(rayDiff.rayYDirection, null, "rayDiff.rayYDirection is expected to be null")
    equal(rayDiff.scaleDifferentials?, true, "rayDiff should have the function scaleDifferentials")
    return
  )
  
  test("New RayDifferential from Ray", ->
    rayDiff = RayDifferential.FromRay(new Ray(new Point(0,0,0), new Vector(2, 2, 2), 1))
    equal(rayDiff.origin.x, 0, "rayDiff.origin.x is expected to be equal to 0")
    equal(rayDiff.origin.y, 0, "rayDiff.origin.y is expected to be equal to 0")
    equal(rayDiff.origin.z, 0, "rayDiff.origin.z is expected to be equal to 0")
    equal(rayDiff.direction.x, 2, "rayDiff.direction.x is expected to be equal to 2")
    equal(rayDiff.direction.y, 2, "rayDiff.direction.y is expected to be equal to 2")
    equal(rayDiff.direction.z, 2, "rayDiff.direction.z is expected to be equal to 2")
    equal(rayDiff.parent, null, "rayDiff.parent is expected to be null")
    equal(rayDiff.minTime, 1, "rayDiff.minTime is expected to be 1")
    equal(rayDiff.maxTime, Infinity, "rayDiff.maxTime is expected to be Infinity")
    equal(rayDiff.time, 0, "rayDiff.time is expected to be 0")
    equal(rayDiff.depth, 0, "rayDiff.depth is expected to be 0")
    equal(rayDiff.hasDifferentials, false, "rayDiff.hasDifferentials is expected to be false")
    equal(rayDiff.rayXOrigin, null, "rayDiff.rayXOrigin is expected to be null")
    equal(rayDiff.rayYOrigin, null, "rayDiff.rayYOrigin is expected to be null")
    equal(rayDiff.rayXDirection, null, "rayDiff.rayXDirection is expected to be null")
    equal(rayDiff.rayYDirection, null, "rayDiff.rayYDirection is expected to be null")
    equal(rayDiff.scaleDifferentials?, true, "rayDiff should have the function scaleDifferentials")
    return
  )
  
  test("RayDifferential scaleDifferentials with instance function", ->
    throw Error "TODO"
  )
  
  module("BoundingBox")
  
  test("New BoundingBox, no args", ->
    bbox = new BoundingBox
    equal(bbox.constructor.name, "BoundingBox", "bbox should be of class 'BoundingBox'")
    equal(bbox.pMin.x, Infinity, "bbox.pMin.x is expected to be equal to Infinity")
    equal(bbox.pMin.y, Infinity, "bbox.pMin.y is expected to be equal to Infinity")
    equal(bbox.pMin.z, Infinity, "bbox.pMin.z is expected to be equal to Infinity")
    equal(bbox.pMax.x, -Infinity, "bbox.pMax.x is expected to be equal to -Infinity")
    equal(bbox.pMax.y, -Infinity, "bbox.pMax.y is expected to be equal to -Infinity")
    equal(bbox.pMax.z, -Infinity, "bbox.pMax.z is expected to be equal to -Infinity")
    return
  )
  
  test("New BoundingBox, 1 arg", ->
    bbox = new BoundingBox(null, new Point(1, 2, 3))
    equal(bbox.constructor.name, "BoundingBox", "bbox should be of class 'BoundingBox'")
    equal(bbox.pMin.x, 1, "bbox.pMin.x is expected to be equal to 1")
    equal(bbox.pMin.y, 2, "bbox.pMin.y is expected to be equal to 2")
    equal(bbox.pMin.z, 3, "bbox.pMin.z is expected to be equal to 3")
    equal(bbox.pMax.x, bbox.pMin.x, "bbox.pMax.x is expected to be equal to bbox.pMin.x")
    equal(bbox.pMax.y, bbox.pMin.y, "bbox.pMax.y is expected to be equal to bbox.pMin.y")
    equal(bbox.pMax.z, bbox.pMin.z, "bbox.pMax.z is expected to be equal to bbox.pMin.z")
    bbox = new BoundingBox(new Point(1, 2, 3), null)
    equal(bbox.constructor.name, "BoundingBox", "bbox should be of class 'BoundingBox'")
    equal(bbox.pMin.x, 1, "bbox.pMin.x is expected to be equal to 1")
    equal(bbox.pMin.y, 2, "bbox.pMin.y is expected to be equal to 2")
    equal(bbox.pMin.z, 3, "bbox.pMin.z is expected to be equal to 3")
    equal(bbox.pMax.x, bbox.pMin.x, "bbox.pMax.x is expected to be equal to bbox.pMin.x")
    equal(bbox.pMax.y, bbox.pMin.y, "bbox.pMax.y is expected to be equal to bbox.pMin.y")
    equal(bbox.pMax.z, bbox.pMin.z, "bbox.pMax.z is expected to be equal to bbox.pMin.z")
    return
  )
  
  test("New BoundingBox, 2 arg", ->
    bbox = new BoundingBox(new Point(-1, 2, -3), new Point(-4, 3, -6))
    equal(bbox.constructor.name, "BoundingBox", "bbox should be of class 'BoundingBox'")
    equal(bbox.pMin.x, -4, "bbox.pMin.x is expected to be equal to -4")
    equal(bbox.pMin.y, 2, "bbox.pMin.y is expected to be equal to 2")
    equal(bbox.pMin.z, -6, "bbox.pMin.z is expected to be equal to -6")
    equal(bbox.pMax.x, -1, "bbox.pMax.x is expected to be equal to -1")
    equal(bbox.pMax.y, 3, "bbox.pMax.y is expected to be equal to 3")
    equal(bbox.pMax.z, -3, "bbox.pMax.z is expected to be equal to -3")
    return
  )
  
  test("Union of BoundingBox and Point", ->
    unionBBox = BoundingBox.UnionBBoxAndPoint(new BoundingBox(new Point(-1, 2, -3), new Point(-4, 3, -6)), new Point(-5, 6, 6))
    equal(unionBBox.constructor.name, "BoundingBox", "unionBBox should be of class 'BoundingBox'")
    equal(unionBBox.pMin.x, -5, "unionBBox.pMin.x is expected to be equal to -4")
    equal(unionBBox.pMin.y, 2, "unionBBox.pMin.y is expected to be equal to 2")
    equal(unionBBox.pMin.z, -6, "unionBBox.pMin.z is expected to be equal to -6")
    equal(unionBBox.pMax.x, -1, "unionBBox.pMax.x is expected to be equal to -1")
    equal(unionBBox.pMax.y, 6, "unionBBox.pMax.y is expected to be equal to 6")
    equal(unionBBox.pMax.z, 6, "unionBBox.pMax.z is expected to be equal to 6")
    return
  )
  
  test("Union of BoundingBox and BoundingBox", ->
    unionBBox = BoundingBox.UnionBBoxAndBBox(new BoundingBox(new Point(-1, 2, -3), new Point(-4, 3, -6)), new BoundingBox(new Point(-6, 2, 3), new Point(-4, 6, 9)))
    equal(unionBBox.constructor.name, "BoundingBox", "unionBBox should be of class 'BoundingBox'")
    equal(unionBBox.pMin.x, -6, "unionBBox.pMin.x is expected to be equal to -6")
    equal(unionBBox.pMin.y, 2, "unionBBox.pMin.y is expected to be equal to 2")
    equal(unionBBox.pMin.z, -6, "unionBBox.pMin.z is expected to be equal to -6")
    equal(unionBBox.pMax.x, -1, "unionBBox.pMax.x is expected to be equal to -1")
    equal(unionBBox.pMax.y, 6, "unionBBox.pMax.y is expected to be equal to 6")
    equal(unionBBox.pMax.z, 9, "unionBBox.pMax.z is expected to be equal to 9")
    return
  )
  
  test("BoundingBox Equals with static function", ->
    bbox1 = new BoundingBox(new Point(-1, 2, -3), new Point(-4, 3, -6))
    bbox2 = new BoundingBox(new Point(-1, 2, -3), new Point(-4, 3, -6))
    bbox3 = new BoundingBox(new Point(-4, 3, -3), new Point(-1, 2, -6))
    bbox4 = new BoundingBox(new Point(1, 2, 3), new Point(4, 4, 5))
    equal(BoundingBox.Equals(bbox1, bbox2), true, "bbox1 is expected to be equal to bbox2")
    equal(BoundingBox.Equals(bbox1, bbox3), true, "bbox1 is expected to be equal to bbox3")
    equal(BoundingBox.Equals(bbox3, bbox4), false, "bbox3 is expected to not be equal to bbox4")
    return
  )
  
  test("BoundingBox Overlaps with static function", ->
    bbox1 = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    bbox2 = new BoundingBox(new Point(1, 1, 1), new Point(3, 3, 3))
    bbox3 = new BoundingBox(new Point(3, 3, 3), new Point(4, 4, 4))
    equal(BoundingBox.Overlaps(bbox1, bbox2), true, "bbox2 is expected to overlap bbox1")
    equal(BoundingBox.Overlaps(bbox1, bbox3), false, "bbox3 is expected to not overlap bbox1")
    return
  )
  
  test("BoundingBox Inside with static function", ->
    equal(BoundingBox.Inside(new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2)), new Point(1, 1, 1)), true, "Point is expected to be inside BoundingBox")
    equal(BoundingBox.Inside(new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2)), new Point(3, 1, 1)), false, "Point is expected to not be inside BoundingBox")
    return
  )
  
  test("BoundingBox expand with instance function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    bbox.expand(3)
    equal(bbox.pMin.x, -3, "bbox.pMin.x is expected to be -3")
    equal(bbox.pMin.y, -3, "bbox.pMin.y is expected to be -3")
    equal(bbox.pMin.z, -3, "bbox.pMin.z is expected to be -3")
    equal(bbox.pMax.x, 5, "bbox.pMax.x is expected to be 5")
    equal(bbox.pMax.y, 5, "bbox.pMax.y is expected to be 5")
    equal(bbox.pMax.z, 5, "bbox.pMax.z is expected to be 5")
    return
  )
  
  test("BoundingBox surfaceArea with instance function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    sa = bbox.surfaceArea()
    equal(sa, 24, "bbox surface area is expected to be 24")
    return
  )
  
  test("BoundingBox volume with instance function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    v = bbox.volume()
    equal(v, 8, "bbox volume is expected to be 24")
    return
  )
  
  test("BoundingBox maximumExtent with instance function", ->
    bbox1 = new BoundingBox(new Point(0, 0, 0), new Point(2, 1, 1))
    me1 = bbox1.maximumExtent()
    bbox2 = new BoundingBox(new Point(0, 0, 0), new Point(1, 2, 1))
    me2 = bbox2.maximumExtent()
    bbox3 = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    me3 = bbox3.maximumExtent()
    equal(me1, 0, "bbox1 maximum extent is expected to be 0")
    equal(me2, 1, "bbox2 maximum extent is expected to be 1")
    equal(me3, 2, "bbox3 maximum extent is expected to be 2")
    return
  )
  
  test("BoundingBox toArray with instance function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    arr = bbox.toArray()
    equal(arr[0].x, 0, "arr[0].x is expected to be 0")
    equal(arr[0].y, 0, "arr[0].y is expected to be 0")
    equal(arr[0].z, 0, "arr[0].z is expected to be 0")
    equal(arr[1].x, 2, "arr[0].x is expected to be 2")
    equal(arr[1].y, 2, "arr[0].y is expected to be 2")
    equal(arr[1].z, 2, "arr[0].z is expected to be 2")
    return
  )
  
  test("BoundingBox LinearInterpolation with static function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    interpolated = BoundingBox.LinearInterpolation(bbox, 0, 0.5, 1)
    equal(interpolated.x, 0, "interpolated.x is expected to be 1")
    equal(interpolated.y, 1, "interpolated.y is expected to be 1")
    equal(interpolated.z, 2, "interpolated.z is expected to be 1")
    return
  )
  
  test("BoundingBox Offset with static function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    offset = BoundingBox.Offset(bbox, new Point(0, 1, 2))
    equal(offset.x, 0, "interpolated.x is expected to be 0")
    equal(offset.y, 0.5, "interpolated.y is expected to be 0.5")
    equal(offset.z, 1, "interpolated.z is expected to be 1")
    return
  )
  
  test("BoundingBox boundingSphere with instance function", ->
    bbox = new BoundingBox(new Point(0, 0, 0), new Point(2, 2, 2))
    [center, radius] = bbox.boundingSphere()
    equal(center.x, 1, "center.x is expected to be 1")
    equal(center.y, 1, "center.y is expected to be 1")
    equal(center.z, 1, "center.z is expected to be 1")
    equal(radius, Math.sqrt(3), "radius is expected to be sqrt(3)")
    return
  )
)