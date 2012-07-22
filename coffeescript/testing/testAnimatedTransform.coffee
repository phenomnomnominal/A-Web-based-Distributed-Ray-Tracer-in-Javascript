$(document).ready ->
  
  module 'Quaternion - constructor'
  
  test 'Test creating a new Quaternion, supplying no arguments to the
        constructor:', ->
    expect 6
    ok Quaternion?, 'If we create the default Quaternion by calling "new
                     Quaternion" with no arguments,'
    q = new Quaternion
    ok q? and q.constructor.name is 'Quaternion',
      'the constructor should return a Quaternion'
    ok q.v? and q.v.constructor.name is 'Vector',
      'which has a v property that is a Vector'
    ok q.w? and _.isNumber(q.w), 'and a w property which is a number.'
    ok Vector.Equals(q.v, new Vector(0,0,0)),
      'The v property is expected to be a null Vector (0,0,0)'
    ok q.w is 1, 'and the w property is expected to be equal to 1.'

  test 'Test for Errors when passing incorrect arguments to the requied
        parameters of the Quaternion constructor:', ->
    expect 6
    notVector = "NOT A VECTOR"
    ok notVector?, 'If we crete a non-Vector object'
    ok Quaternion?, 'and attempt to create a Quaternion by passing it
                     into the constructor as v'
    raises (-> q = new Quaternion(notVector))
      , /Quaternion Constructor Error: v must be a Vector./,
      'an Error is thrown: Quaternion Constructor Error: v must be a Vector.'
    v = new Vector()
    ok v?, 'If we create a v Vector and pass it into the constructor'
    notNumber = 'NOT A NUMBER'
    ok notNumber?, 'along with a non-Number Object as w'
    raises (-> q = new Quaternion(v, notNumber))
      , /Quaternion Constructor Error: w must be a Number./,
      'an Error is thrown: Quaternion Constructor Error: w must be a Number.'
    
  test 'Test creating a new Quaternion from a Vector and a number:', ->
    expect 6
    ok Quaternion?, 'If we create a Quaternion by calling "new Quaternion"
                     with a Vector and a number as arguments,'
    q = new Quaternion(new Vector(3, 4, 5), 6)
    ok q? and q.constructor.name is 'Quaternion',
      'the constructor should return a Transform'
    ok q.v? and q.v.constructor.name is 'Vector',
      'which has a v property that is a Vector'
    ok q.w? and _.isNumber(q.w), 'and a w property which is a number.'
    ok Vector.Equals(q.v, new Vector(3,4,5)), 'The v property is expected to be
                                    the original Vector - in this case (3,4,5)'
    equal q.w, 6, 'and the w property is expected to be equal to the number -
                   in this case 6.'
  
  module 'Quaternion - Prototype functions'
  
  test 'Test that all Prototype functions exist on a Quaternion:', ->
    expect 5
    q = new Quaternion()
    ok q?, 'If we create a Quaternion'
    ok q.add?, 'it should have a "add" function,'
    ok q.subtract?, 'a "subtract" function,'
    ok q.multiply?, 'a "multiply" function'
    ok q.divide?, 'and a "divide" function.'
  
  test 'Test that "add" works correctly for Quaternion instances:', ->
    expect 9
    ok Quaternion?, 'If we create a three Quaternion instances,'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q2 = new Quaternion(new Vector(3, 4, 5), 6)
    q3 = new Quaternion(new Vector(6, 7, 8), 9)
    ok q1? and q2?, 'two of which are identical'
    ok q3?, 'and a third which is different,'
    q1copy = q1
    q2copy = q2
    q1.add q3
    q3.add q2
    ok q1 is q1copy,
      'If we call "q1.add q3", q1 should be changed in place,'
    ok q2 is q2copy,
      'and if we call "q3.add q2"", q3 should be changed in place.'
    ok Vector.Equals(q1.v, new Vector(9, 11, 13)),
      'The Vector addition should give (9, 11, 13),'
    equal q1.w, 15, 'and the addition of the W components should give 15.'
    ok Vector.Equals(q1.v, q3.v), 'The Vector addition should give the same
                                   result no matter in what order it happens,'
    ok q1.w is q3.w, 'and the same for the W components.'
  
  test 'Test that "subtract" works correctly for Quaternion instances:', ->
    expect 9
    ok Quaternion?, 'If we create a three Quaternion instances,'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q2 = new Quaternion(new Vector(3, 4, 5), 6)
    q3 = new Quaternion(new Vector(6, 7, 8), 9)
    ok q1? and q2?, 'two of which are identical'
    ok q3?, 'and a third which is different,'
    q1copy = q1
    q2copy = q2
    q1.subtract q3
    q3.subtract q2
    ok q1 is q1copy,
      'If we call "q1.subtract q3", q1 should be changed in place,'
    ok q2 is q2copy,
      'and if we call "q3.subtract q2", q3 should be changed in place.'
    ok Vector.Equals(q1.v, new Vector(-3, -3, -3)),
      'The first Vector subtraction should give (-3, -3, -3),'
    equal q1.w, -3, 'and the subtraction of the W components should give 15.'
    ok Vector.Equals(q3.v, new Vector(3, 3, 3)),
      'The second Vector subtraction should give (3, 3, 3),'
    equal q3.w, 3, 'and the subtraction of the W components should give 3.'
  
  test 'Test that "multiply" works correctly for Quaternion instances:', ->
    expect 4
    ok Quaternion?, 'If we create a Quaternion instance'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q1copy = q1
    q1.multiply 3
    ok q1 is q1copy,
      'If we call "q1.multiply 3", q1 should be changed in place,'
    ok Vector.Equals(q1.v, new Vector(9, 12, 15)),
      'The Vector multiplication should give (9, 12, 15),'
    equal q1.w, 18, 'and the W component multiplication should give 18.'
  
  test 'Test that "divide" works correctly for Quaternion instances:', ->
    expect 6
    ok Quaternion?, 'If we create a Quaternion instance'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q1copy = q1
    q1.divide 3
    ok q1 is q1copy, 'If we call "q1.divide 3", q1 should be changed in place,'
    equalWithin q1.v.x, 1, 15,
      'The Vector division should give an X component of 1,'
    equalWithin q1.v.y, 4/3, 15,
      'The Vector division should give an Y component of 4/3,'
    equalWithin q1.v.z, 5/3, 15,
      'The Vector division should give an Z component of 5/3,'
    equal q1.w, 2, 'and the W component division should give 2.'
      
  module "Quaternion - Static functions"
  
  test 'Test that all Prototype functions exist on the Quaternion class:', ->
    expect 10
    ok Quaternion?, 'The Quaternion class'
    ok Quaternion.ToTransform?, 'should have a "ToTransform" function,'
    ok Quaternion.FromTransform?, 'a "FromTransform" function,'
    ok Quaternion.Add?, ' a "Add" function,'
    ok Quaternion.Subtract?, 'a "Subtract" function,'
    ok Quaternion.Multiply?, 'a "Multiply" function,'
    ok Quaternion.Divide?, 'a "Divide" function,'
    ok Quaternion.Dot?, 'a "Dot" function,'
    ok Quaternion.Normalise?, 'a "Normalise" function'
    ok Quaternion.SphericalLinearInterpolation?,
      'and a "SphericalLinearInterpolation" function.'
  
  test 'Test that "ToTransform" works correctly for Quaternion instances:', ->
    expect 7
    ok Quaternion?, 'If we create a Quaternion instance'
    q = new Quaternion(new Vector(0.5, 0.5, 0.5), 0.5)
    ok Quaternion.ToTransform?,
      'and convert it to a Transform using "Quaternion.ToTransform",'
    t = Quaternion.ToTransform q
    ok t? and t.constructor.name is 'Transform',
      'the function should return a Transform'
    ok t.matrix? and t.matrix.constructor.name is 'Matrix4x4',
      'which has a matrix property that is a Matrix4x4'
    ok t.inverse? and t.inverse.constructor.name is 'Matrix4x4',
      'and an inverse property that is a Matrix4x4.'
    tm = new Matrix4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
    tinv = new Matrix4x4([[0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1]])
    ok Matrix4x4.Equals(t.matrix, tm),
      'The matrix property is expected to be equal to a known matrix
       [[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]]'
    ok Matrix4x4.Equals(t.inverse, tinv),
      'and the inverse property is expected to be equal a known inverse
       [[0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1]]'
  
  test 'Test that "FromTransform" works correctly for Quaternion instances:', ->
    expect 7
    m = new Matrix4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
    inv = new Matrix4x4([[0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1]])
    ok m? and inv?,
      'If we start with a known transformation matrix and its known inverse,'
    ok Quaternion.FromTransform?, 'and create a new Quaternion instance from
                                   them using "Quaternion.FromTransform",'
    q = Quaternion.FromTransform(new Transform(m, inv))
    ok q? and q.constructor.name is 'Quaternion',
      'the function should return a Quaternion'
    ok q.v? and q.v.constructor.name is 'Vector',
      'which has a v property that is a Vector'
    ok q.w?, 'and an w property that is a number.'
    ok Vector.Equals(q.v, new Vector(0.5, 0.5, 0.5)),
      'The v property is expected to be equal to a known Vector(0.5, 0.5, 0.5)'
    equal q.w, 0.5, 'and the w property is expected to be equal to 0.5'
  
  test 'Test that "Add" works correctly for Quaternion instances:', ->
    expect 7
    ok Quaternion?, 'If we create a two Quaternion instances'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q2 = new Quaternion(new Vector(6, 7, 8), 9)
    qAdd1 = Quaternion.Add q1, q2
    qAdd2 = Quaternion.Add q2, q1
    ok q1 isnt qAdd1,
      'and we call "Quaternion.Add q1, q2", q1 should be unchanged'
    ok q2 isnt qAdd2,
      'and if we call "Quaternion.Add q2, q1", q2 should be unchanged.'
    ok Vector.Equals(qAdd1.v, new Vector(9, 11, 13)),
      'The Vector addition should give (9, 11, 13)'
    equal qAdd1.w, 15,
      'and the addition of the W components should give 15.'
    ok Vector.Equals(qAdd1.v, qAdd2.v), 'The Vector addition should give the
                               same result no matter in what order it happens,'
    ok qAdd1.w is qAdd2.w, 'and the same for the W components.'
  
  test 'Test that "Subtract" works correctly for Quaternion instances:', ->
    expect 7
    ok Quaternion?, 'If we create a two Quaternion instances'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q2 = new Quaternion(new Vector(6, 7, 8), 9)
    qSubtract1 = Quaternion.Subtract q1, q2
    qSubtract2 = Quaternion.Subtract q2, q1
    ok q1 isnt qSubtract1,
      'and we call "Quaternion.Subtract q1, q2", q1 should be unchanged'
    ok q2 isnt qSubtract2,
      'and if we call "Quaternion.Subtract q2, q1", q2 should be unchanged.'
    ok Vector.Equals(qSubtract1.v, new Vector(-3, -3, -3)),
      'The first Vector subtraction should give (-3, -3, -3)'
    equal qSubtract1.w, -3,
      'and the subtraction of the W components should give 15.'
    ok Vector.Equals(qSubtract2.v, new Vector(3, 3, 3)), "The second Vector
                                            subtraction should give (3, 3, 3)"
    equal qSubtract2.w, 3,
      'and the subtraction of the W components should give 3.'
  
  test 'Test that "Multiply" works correctly for Quaternion instances', ->
    expect 4
    ok Quaternion?, 'If we create a Quaternion instance'
    q = new Quaternion(new Vector(3, 4, 5), 6)
    qMul = Quaternion.Multiply q, 3
    ok q isnt qMul,
      'and we call "Quaternion.Multiply q, 3", q should be unchanged.'
    ok Vector.Equals(qMul.v, new Vector(9, 12, 15)),
      'The Vector multiplication should give (9, 12, 15),'
    equal qMul.w, 18, 'and the W component multiplication should give 18.'
  
  test 'Test that "Divide" works correctly for Quaternion instances', ->
    expect 6
    ok Quaternion?, 'If we create a Quaternion instance'
    q = new Quaternion(new Vector(3, 4, 5), 6)
    qDivide = Quaternion.Divide q, 3
    ok q isnt qDivide,
      'and we call "Quaternion.Divide q, 3", q should be unchanged.'
    equalWithin qDivide.v.x, 1, 15,
      'The Vector division should give an X component of 1,'
    equalWithin qDivide.v.y, 4/3, 15,
      'The Vector division should give an Y component of 4/3,'
    equalWithin qDivide.v.z, 5/3, 15,
      'The Vector division should give an Z component of 5/3,'
    equal qDivide.w, 2, 'and the W component division should give 2.'
  
  test 'Test that "Dot" works correctly on Quaternion instances', ->
    expect 3
    ok Quaternion?, 'If we create a two Quaternion instances'
    q1 = new Quaternion(new Vector(3, 4, 5), 6)
    q2 = new Quaternion(new Vector(5, 6, 7), 8)
    ok Quaternion.Dot?,
      'and compute their Dot Product using "Quaternion.Dot,"'
    qDot = Quaternion.Dot q1, q2
    equal qDot, 122, 'the result should be 122.'
  
  test 'Test that "Normalise" works correctly on Quaternion instances', ->
    expect 7
    ok Quaternion?, 'If we create a Quaternion instance'
    q = new Quaternion(new Vector(3, 3, 3), 3)
    ok Quaternion.Dot?, 'and nomalise it using "Quaternion.Normalise",'
    qNorm = Quaternion.Normalise q
    ok qNorm? and qNorm.constructor.name is 'Quaternion',
      'the function should return a Quaternion'
    ok qNorm.v? and qNorm.v.constructor.name is 'Vector',
      'which has a v property that is a Vector'
    ok qNorm.w?, 'and an w property that is a number.'
    ok Vector.Equals(qNorm.v, new Vector(0.5, 0.5, 0.5)),
      'The v property is expected to be equal to a known Vector(0.5, 0.5, 0.5)'
    equal qNorm.w, 0.5, 'and the w property is expected to be equal to 0.5'