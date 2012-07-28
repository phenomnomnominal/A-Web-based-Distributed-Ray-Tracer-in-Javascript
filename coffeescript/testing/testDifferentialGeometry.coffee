$(document).ready ->
  
  module 'DifferentialGeometry - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the required parameters of the DifferentialGeometry constructor:', ->
    expect 22
    ok DifferentialGeometry?, 'If we create a DifferentialGeometry by calling "new DifferentialGeometry" with no arguments'
    raises ->
        dg = new DifferentialGeometry()
      , /point must be defined./, 'a DiffGeoConstructorError is thrown: "point must be defined."'
    notPoint = 'NOT A POINT'
    ok notPoint?, 'If we pass a non-Point Object into the constructor as point'
    raises ->
        dg = new DifferentialGeometry(notPoint)
      , /point must be a Point./, 'a DiffGeoConstructorError is thrown: "point must be a Point."' 
    p = new Point()
    ok p?, 'If we create a point Point and pass it into the constructor'
    raises ->
        dg = new DifferentialGeometry(p)
      , /dpdu must be defined./, 'a DiffGeoConstructorError is thrown: "dpdu must be defined."'
    notVector = 'NOT A VECTOR'
    ok notVector?, 'If we pass a non-Vector Object into the constructor as dpdu'
    raises ->
        dg = new DifferentialGeometry(p, notVector)
      , /dpdu must be a Vector./, 'a DiffGeoConstructorError is thrown: "dpdu must be a Vector."'
    dpdu = new Vector(1, 0, 0)
    ok dpdu?, 'If we create a dpdu Vector and pass it into the constructor'
    raises ->
        dg = new DifferentialGeometry(p, dpdu)
      , /dpdv must be defined./, 'a DiffGeoConstructorError is thrown: "dpdv must be defined."'
    notVector = 'NOT A VECTOR'
    ok notVector?, 'If we pass a non-Vector Object into the constructor as dpdv'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, notVector)
      , /dpdv must be a Vector./, 'a DiffGeoConstructorError is thrown: "dpdv must be a Vector."' 
    dpdv = new Vector(0, 1, 0)
    ok dpdv?, 'If we create a dpdu Vector and pass it into the constructor'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv)
      , /dndu must be defined./, 'a DiffGeoConstructorError is thrown: "dndu must be defined."'
    notNormal = 'NOT A NORMAL'
    ok notNormal, 'If we pass a non-Normal Object into the constructor as dndu'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, notNormal)
      , /dndu must be a Normal./, 'a DiffGeoConstructorError is thrown: "dndu must be a Normal."'
    dndu = new Normal()
    ok dndu?, 'If we create a dndu Normal and pass it into the constructor'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, dndu)
      , /dndv must be defined./, 'a DiffGeoConstructorError is thrown: "dndv must be defined."'
    notNormal = 'NOT A NORMAL'
    ok notNormal, 'If we pass a non-Normal Object into the constrcutor as dndv'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, dndu, notNormal)
      , /dndv must be a Normal./, 'a DiffGeoConstructorError is thrown: "dndv must be a Normal."'
    dndv = new Normal()
    ok dndv?, 'If we create a dndv Normal and pass it into the constructor'
    dg = new DifferentialGeometry(p, dpdu, dpdv, dndu, dndv)
    ok dg?, 'we will get a DifferentialGeoemetry Object'
    
  test 'Test for Errors when passing incorrect values to the parameters of the TriangleMesh constructor that have default arguments:', ->
    expect 6
    p = new Point()
    dpdu = new Vector(1, 0, 0)
    dpdv = new Vector(0, 1, 0)
    dndu = new Normal()
    dndv = new Normal()
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as u'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, dndu, dndv, notNumber)
      , /u must be a Number./, 'a DiffGeoConstructorError is thrown: "u must be a Number."'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'If we pass a non-Number Object into the constructor as v'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, dndu, dndv, null, notNumber)
      , /v must be a Number./, 'a DiffGeoConstructorError is thrown: "v must be a Number."'
    notShape = 'NOT A SHAPE'
    ok notShape?, 'If we pass a non-Shape Object into the constructor as shape'
    raises ->
        dg = new DifferentialGeometry(p, dpdu, dpdv, dndu, dndv, null, null, notShape)
      , /shape must be a Shape./, 'a DiffGeoConstructorError is thrown: "shape must be a Shape."'
   
  test 'Test creating a new DifferentialGeometry, supplying only the required arguments to the constructor', ->
    expect 27
    ok DifferentialGeometry?, 'If we create a DifferentialGeometry by calling "new DifferentialGeometry" with the required arguments,'
    p = new Point(0, 0, 0)
    vU = new Vector(0, 0, 1)
    vV = new Vector(1, 0, 0)
    nU = new Normal(0, 0, 1)
    nV = new Normal(1, 0, 0)
    normNorm = new Normal(0, 1, 0)
    dg = new DifferentialGeometry(p, vU, vV, nU, nV)
    ok dg? and dg instanceof DifferentialGeometry, 'the constructor should return a DifferentialGeometry'
    ok dg.point? and dg.point instanceof Point, 'which has a "point" property that is a Point,'
    ok Point.Equals(dg.point, p), 'that is equal to the argument "p" (0, 0, 0)'
    ok dg.dpdu? and dg.dpdu instanceof Vector, 'and a "dpdu" property that is a Vector,'
    ok Vector.Equals(dg.dpdu, vU), 'that is equal to the argument "vU" (0, 0, 1)'
    ok dg.dpdv? and dg.dpdv instanceof Vector, 'and a "dpdv" property that is a Vector,'
    ok Vector.Equals(dg.dpdv, vV), 'that is equal to the argument "vV" (1, 0, 0)'
    ok dg.dndu? and dg.dndu instanceof Normal, 'and a "dndu" property that is a Normal,'
    ok Normal.Equals(dg.dndu, nU), 'that is equal to the argument "nU" (0, 0, 1)'
    ok dg.dndv? and dg.dndv instanceof Normal, 'and a "dndv" property that is a Normal,'
    ok Normal.Equals(dg.dndv, nV), 'that is equal to the argument "nV" (1, 0, 0)'
    ok dg.u? and _.isNumber(dg.u), 'and a "u" property that is a Number,'
    equal dg.u, 0, 'that is equal to the default value (0)'
    ok dg.v? and _.isNumber(dg.v), 'and a "v" property that is a Number,'
    equal dg.v, 0, 'that is equal to the default value (0)'
    equal dg.shape, null, 'and a "shape" property that is null'
    ok dg.dudx? and _.isNumber(dg.dudx), 'and a "dudx" property that is a Number'
    equal dg.dudx, 0, 'that is equal to the default value (0)'
    ok dg.dvdx? and _.isNumber(dg.dvdx), 'and a "dvdx" property that is a Number'
    equal dg.dvdx, 0, 'that is equal to the default value (0)'
    ok dg.dudy? and _.isNumber(dg.dudy), 'and a "dudy" property that is a Number'
    equal dg.dudy, 0, 'that is equal to the default value (0)'
    ok dg.dvdy? and _.isNumber(dg.dvdy), 'and a "dvdy" property that is a Number'
    equal dg.dvdy, 0, 'that is equal to the default value (0)'
    ok dg.normalisedNormal? and dg.normalisedNormal instanceof Normal, 'and a "normalisedNormal" property that is a Normal'
    ok Normal.Equals(dg.normalisedNormal, normNorm), 'that is equal to "normNorm" (0, 1, 0)'