$(document).ready(->

  module("Matrix")
  
  test("New Matrix", ->
    m = new Matrix4x4
    equal(m.m[0][0], 1, "Default matrix [0][0] is expected to be 1")   
    equal(m.m[0][1], 0, "Default matrix [0][1] is expected to be 0")   
    equal(m.m[0][2], 0, "Default matrix [0][2] is expected to be 0")   
    equal(m.m[0][3], 0, "Default matrix [0][3] is expected to be 0")   
    equal(m.m[1][0], 0, "Default matrix [1][0] is expected to be 0")   
    equal(m.m[1][1], 1, "Default matrix [1][1] is expected to be 1")   
    equal(m.m[1][2], 0, "Default matrix [1][2] is expected to be 0")   
    equal(m.m[1][3], 0, "Default matrix [1][3] is expected to be 0")   
    equal(m.m[2][0], 0, "Default matrix [2][0] is expected to be 0")   
    equal(m.m[2][1], 0, "Default matrix [2][1] is expected to be 0")   
    equal(m.m[2][2], 1, "Default matrix [2][2] is expected to be 1")   
    equal(m.m[2][3], 0, "Default matrix [2][3] is expected to be 0")   
    equal(m.m[3][0], 0, "Default matrix [3][0] is expected to be 0")   
    equal(m.m[3][1], 0, "Default matrix [3][1] is expected to be 0")   
    equal(m.m[3][2], 0, "Default matrix [3][2] is expected to be 0")   
    equal(m.m[3][3], 1, "Default matrix [3][3] is expected to be 1")
  )
  
  test("New Matrix from Array", ->
    m = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    equal(m.m[0][0], 1, "Matrix [0][0] is expected to be 1")   
    equal(m.m[0][1], 2, "Matrix [0][1] is expected to be 2")   
    equal(m.m[0][2], 3, "Matrix [0][2] is expected to be 3")   
    equal(m.m[0][3], 4, "Matrix [0][3] is expected to be 4")   
    equal(m.m[1][0], 1.5, "Matrix [1][0] is expected to be 1.5")   
    equal(m.m[1][1], -2.5, "Matrix [1][1] is expected to be -2.5")   
    equal(m.m[1][2], 4, "Matrix [1][2] is expected to be 4")   
    equal(m.m[1][3], 9, "Matrix [1][3] is expected to be 9")   
    equal(m.m[2][0], 0, "Matrix [2][0] is expected to be 0")   
    equal(m.m[2][1], 0, "Matrix [2][1] is expected to be 0")   
    equal(m.m[2][2], 0, "Matrix [2][2] is expected to be 0")   
    equal(m.m[2][3], 0, "Matrix [2][3] is expected to be 0")   
    equal(m.m[3][0], 4, "Matrix [3][0] is expected to be 4")   
    equal(m.m[3][1], -2, "Matrix [3][1] is expected to be -2")   
    equal(m.m[3][2], 1, "Matrix [3][2] is expected to be 1")   
    equal(m.m[3][3], 1, "Matrix [3][3] is expected to be 1")   
  )
  
  test("Matrix Equals with static function", ->
    m1 = new Matrix4x4
    m2 = new Matrix4x4
    m3 = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    equal(Matrix4x4.Equals(m1, m2), true, "m1 is expected to be equal to m2")  
    equal(Matrix4x4.Equals(m1, m3), false, "m1 is expected to not be equal to m3")
    equal(Matrix4x4.Equals(m1, 3), false, "m1 is expected to be equal to 3")
    return 
  )
  
  test("Matrix Equals with static function", ->
    m1 = new Matrix4x4
    m2 = new Matrix4x4
    m3 = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    equal(m1.equals(m2), true, "m1 is expected to be equal to m2")  
    equal(m1.equals(m3), false, "m1 is expected to not be equal to m3")
    equal(m1.equals(3), false, "m1 is expected to be equal to 3")
    return
  )
  
  test("Matrix IsIdentity with static function", ->
    m1 = new Matrix4x4
    equal(Matrix4x4.IsIdentity(m1), true, "m1 is expected to be the Identity matrix")
    m2 = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    equal(Matrix4x4.IsIdentity(m2), false, "m2 is expected to not be the Identity matrix")
    return
  )
  
  test("Matrix Transpone with static function", ->
    m1 = new Matrix4x4
    m1T = Matrix4x4.Transpose(m1)
    equal(Matrix4x4.Equals(m1, m1T), true, "m1 (The Identity) is expected to equal to its Transpose.")
    m2 = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    m2T = Matrix4x4.Transpose(m2)
    equal(m2T.m[0][0], 1, "Transpose of m2 [0][0] is expected to be 1")   
    equal(m2T.m[0][1], 1.5, "Transpose of m2 [0][1] is expected to be 1.5")   
    equal(m2T.m[0][2], 0, "Transpose of m2 [0][2] is expected to be 0")   
    equal(m2T.m[0][3], 4, "Transpose of m2 [0][3] is expected to be 4")   
    equal(m2T.m[1][0], 2, "Transpose of m2 [1][0] is expected to be 2")   
    equal(m2T.m[1][1], -2.5, "Transpose of m2 [1][1] is expected to be -2.5")   
    equal(m2T.m[1][2], 0, "Transpose of m2 [1][2] is expected to be 0")   
    equal(m2T.m[1][3], -2, "Transpose of m2 [1][3] is expected to be -2")   
    equal(m2T.m[2][0], 3, "Transpose of m2 [2][0] is expected to be 3")   
    equal(m2T.m[2][1], 4, "Transpose of m2 [2][1] is expected to be 4")   
    equal(m2T.m[2][2], 0, "Transpose of m2 [2][2] is expected to be 0")   
    equal(m2T.m[2][3], 1, "Transpose of m2 [2][3] is expected to be 1")   
    equal(m2T.m[3][0], 4, "Transpose of m2 [3][0] is expected to be 4")   
    equal(m2T.m[3][1], 9, "Transpose of m2 [3][1] is expected to be 9")   
    equal(m2T.m[3][2], 0, "Transpose of m2 [3][2] is expected to be 0")   
    equal(m2T.m[3][3], 1, "Transpose of m2 [3][3] is expected to be 1")
    return
  )
  
  test("Matrix Multiply with static function", ->
    identity = new Matrix4x4
    m = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    mul = Matrix4x4.Multiply([m, identity]...)
    equal(Matrix4x4.Equals(mul, m), true, "m * identity is expected to be m")
    mul = Matrix4x4.Multiply([m, m]...)
    result = new Matrix4x4([[20,-11,15,26],[33.75, -8.75, 3.5, -7.5],[0,0,0,0],[5,11,5,-1]])
    equal(Matrix4x4.Equals(mul, result), true, "m * m is expected to be [[20,-11,15,26],[33.75, -8.75, 3.5, -7.5],[0,0,0,0],[5,11,5,-1]]")
    mul = Matrix4x4.Multiply([m, m, m]...)
    result = new Matrix4x4([[107.5,15.5,42,7],[-9.375, 104.375, 58.75, 48.75],[0,0,0,0],[17.5,-15.5, 58, 118]])
    equal(Matrix4x4.Equals(mul, result), true, "m * m * m is expected to be [[107.5,15.5,42,7],[-9.375, 104.375, 58.75, 48.75],[0,0,0,0],[17.5,-15.5, 58, 118]]")
    mul = Matrix4x4.Multiply([m, m, m, m]...)
    result = new Matrix4x4([[158.75, 162.25, 391.5, 576.5],[342.1875, -377.1875, 438.125, 950.625], [0,0,0,0], [466.25, -162.25, 108.5, 48.5]])
    equal(Matrix4x4.Equals(mul, result), true, "m * m * m * m is expected to be [[158.75, 162.25, 391.5, 576.6],[342.1875, -377.1875, 438.125, 950.625], [0,0,0,0], [466.25, -162.25, 108.5, 48.5]]")
    return
  )
  
  test("Matrix Inverse with static function", ->
    identity = new Matrix4x4
    inv = Matrix4x4.Inverse(identity)
    equal(Matrix4x4.Equals(inv, identity), true, "identity^-1 is expected to be identity")
    singular = new Matrix4x4([[1,2,3,4],[1.5,-2.5,4,9],[null,null,0,null],[4,-2,1]])
    raises(->
        inv = Matrix4x4.Inverse(singular)
        return
      , /Singular matrix in MatrixInvert/, "Throws Error - Singular Matrix has no Inverse")
    m = new Matrix4x4([[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]])
    inv = Matrix4x4.Inverse(m)
    result = new Matrix4x4([[-0.04,0,-0.08,0.36],[0.34,0,0.18,-0.06],[-0.108,0.2,-0.116,-0.028],[0.12,0,0.24,-0.08]])
    for i in [0..3]
      for j in [0..3]
        equalWithin(inv.m[i][j], result.m[i][j], 15, "inv[#{i}][#{j}] is expected to be result[#{i}][#{j}]")
    return
    )
  return
)