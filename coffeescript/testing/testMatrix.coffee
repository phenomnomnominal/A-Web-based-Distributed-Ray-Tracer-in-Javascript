$(document).ready ->

  module 'Matrix - constructor'
  
  test 'Test for Errors when passing incorrect arguments to the parameters of the Matrix4x4 constructor that have default arguments:', ->
    expect 8
    notArray = 'NOT AN ARRAY'
    ok notArray?, 'If we pass a non-Array object into the constructor as matrix'
    raises ->
        m = new Matrix4x4(notArray)
      , /matrix must be an Array./, 'a MatrixConstructorError is thrown: "matrix must be an Array."'
    shortArray = []
    ok shortArray?, 'If we pass an Array with length < 4 into the constructor as matrix'
    raises ->
        m = new Matrix4x4(shortArray)
      , /matrix must have a length of 4./, 'a MatrixConstructorError is thrown: "matrix must have a length of 4."'
    arrayOfNonArray = [1, 2, 3, 4]
    ok arrayOfNonArray?, 'If we pass an Array with length = 4, but of non-Array objects into the constructor as matrix'
    raises ->
        m = new Matrix4x4(arrayOfNonArray)
      , /each row must be an Array./, 'a MatrixConstructorError is thrown: "each row must be an Array."'
    arrayWithNonNumber = [["a"],[],[],[]]
    ok arrayWithNonNumber?, 'If we pass an Array of Arrays with non-Number values into the constructor as matrix'
    raises ->
        m = new Matrix4x4(arrayWithNonNumber)
      , /each defined value must be a Number./, 'a MatrixConstructorError is thrown: "each defined value must be a Number."'
  
  test 'Test creating a new Matrix, supplying no arguments to the constructor:', ->
    expect 17
    ok Matrix4x4?, 'If we create the default Matrix4x4, by calling "new Matrix4x4" with no arguments'
    m = new Matrix4x4()
    identity = [[1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]]
    for i in [0..3]
      for j in [0..3]
        equal m.m[i][j], identity[i][j], "Matrix [#{i}][#{j}] is expected to be equal to #{identity[i][j]},"
  
  test "Test creating a new Matrix from an existing, uneven Array:", ->
    expect 17
    a = [[1,    2,    3, 4],
         [1.5,  -2.5, 4, 9],
         [null, null, 0, null],
         [4,    -2,   1]]
    expected = [[1,   2,    3, 4],
                [1.5, -2.5, 4, 9],
                [0,   0,    0, 0],
                [4,   -2,   1, 1]]
    ok Matrix4x4?, 'If we create the default Matrix4x4 passing in an existing Array'
    m = new Matrix4x4(a)
    for i in [0..3]
      for j in [0..3]
        equal m.m[i][j], expected[i][j], "Matrix [#{i}][#{j}] is expected to be equal to #{expected[i][j]},"
        
  module 'Matrix4x4 - Prototype functions'
  
  test 'Test that all Prototype functions exist on a Matrix4x4:', ->
    expect 2
    m = new Matrix4x4()
    ok m?, 'If we create a Matrix4x4'
    ok m.equals?, 'it should have a "equals" function'
    
  test 'Test that "equals" works correctly for a Matrix instance:', ->
    expect 6
    m1 = new Matrix4x4
    m2 = new Matrix4x4
    m3 = new Matrix4x4([[2],[],[],[]])
    ok m1? and m2? and m1 instanceof Matrix4x4 and m2 instanceof Matrix4x4, 'If we create two identity Matrxi4x4s by calling the constructor with the no arguments,'
    ok m3? and m3 instanceof Matrix4x4, 'and a third Transform that isn\'t an identity Transform,'
    ok m1.equals(m2), 'calling "equals" on the first with the second as the argument should return yes,'
    ok m2.equals(m1), 'calling "equals" on the second with the first as the argument should return yes,'
    ok !m1.equals(m3), 'calling "equals" on the first with the third as the argument should return no,'
    ok !m1.equals("NOT A MATRIX"), 'and calling "equals" on the first with a non-Matrix Object as the argument should return no.'
    
  module 'Transform - Static functions'

  test 'Test that all Static functions exist on the Matrix4x4 class:', ->
    expect 5
    ok Matrix4x4.Equals?, 'The Matrix4x4 class should have an "Equals" function'
    ok Matrix4x4.IsIdentity?, 'and an "IsIdentity" function'
    ok Matrix4x4.Multiply?, 'and a "Multiply" function'
    ok Matrix4x4.Transpose?, 'and a "Transpose" function'
    ok Matrix4x4.Inverse?, 'and an "Inverse" function.'
  
  test 'Test Matrix equality usign Matrix4x4.Equals:', ->
    expect 6
    m1 = new Matrix4x4
    m2 = new Matrix4x4
    m3 = new Matrix4x4([[2],[],[],[]])
    ok m1? and m2? and m1 instanceof Matrix4x4 and m2 instanceof Matrix4x4, 'If we create two identity Matrxi4x4s by calling the constructor with the no arguments,'
    ok m3? and m3 instanceof Matrix4x4, 'and a third Transform that isn\'t an identity Transform,'
    ok m1.equals(m2), 'calling "equals" on the first with the second as the argument should return yes,'
    ok m2.equals(m1), 'calling "equals" on the second with the first as the argument should return yes,'
    ok !m1.equals(m3), 'calling "equals" on the first with the third as the argument should return no,'
    ok !m1.equals("NOT A MATRIX"), 'and calling "equals" on the first with a non-Matrix Object as the argument should return no.'

  
  test 'Test if a Matrix is an Identity Matrix using Matrix.IsIdentity:', ->
    expect 4
    ok Matrix4x4?, 'If we create the default Matrix4x4 by calling "new Matrix4x4" with no arguments'
    m1 = new Matrix4x4()
    ok Matrix4x4.IsIdentity(m1), 'calling "Matrix4x4.IsIdentity" should return true.'
    m2 = new Matrix4x4([[2],[],[],[]])
    ok m2? and m2 instanceof Matrix4x4, 'If we create the a non-Identity matrix,'
    ok !Matrix4x4.IsIdentity(m2), 'calling "Matrix4x4.IsIdentity" should return false.'
  
  test 'Test Matrix multiplication using Matrix.Multiply:', ->
    expect 53
    identity = new Matrix4x4()
    m = new Matrix4x4([[1,    2,    3, 4],
                       [1.5, -2.5,  4, 9],
                       [null, null, 0, null],
                       [4,   -2,    1]])
    ok identity? and m?, 'If we create two known Matrices, one of which is an identity matrix,'
    mul = Matrix4x4.Multiply [m, identity]...
    ok Matrix4x4.Equals(mul, m), 'their product should be the non-identity matrix.'
    mul = Matrix4x4.Multiply [m, m]...
    ok mul?, 'If we multiply the known matrix by itself,'
    expected = [[20,    -11,   15,   26],
                [33.75, -8.75, 3.5, -7.5],
                [0,      0,    0,    0],
                [5,      11,   5,    -1]]
    for i in [0..3]
      for j in [0..3]
        equal mul.m[i][j], expected[i][j], "Matrix result [#{i}][#{j}] is expected to be equal to #{expected[i][j]},"
    mul = Matrix4x4.Multiply([m, m, m]...)
    ok mul?, 'If we multiply the known matrix by itself two times,'
    expected = [[107.5,  15.5,    42,    7],
                [-9.375, 104.375, 58.75, 48.75],
                [0,      0,       0,     0],
                [17.5,  -15.5,    58,    118]]
    for i in [0..3]
      for j in [0..3]
        equal mul.m[i][j], expected[i][j], "Matrix result [#{i}][#{j}] is expected to be equal to #{expected[i][j]},"
    mul = Matrix4x4.Multiply([m, m, m, m]...)
    ok mul?, 'If we multiply the known matrix by itself three times,'
    expected = [[158.75,    162.25,   391.5,   576.5],
                [342.1875, -377.1875, 438.125, 950.625], 
                [0,         0,        0,       0], 
                [466.25,   -162.25,   108.5,   48.5]]
    for i in [0..3]
      for j in [0..3]
        equal mul.m[i][j], expected[i][j], "Matrix result [#{i}][#{j}] is expected to be equal to #{expected[i][j]},"
    
  test 'Test getting a Transpose with Matrix.Transpose:', ->
    ok Matrix4x4?, 'If we create an identity matrix by calling "identity = new Matrix4x4" with no arguments'
    identity = new Matrix4x4()
    trans = Matrix4x4.Transpose(identity)
    ok trans?, 'and call "trans = Matrix4x4.Transpose(identity)"'
    ok Matrix4x4.IsIdentity(trans), 'the result should also be an identity matrix.'
    m = new Matrix4x4([[1, 2, 3, 4],
                       [3, 4, 5, 6],
                       [5, 6, 7, 8],
                       [7, 8, 9, 10]])
    mExpected = [[1, 3, 5, 7],
                 [2, 4, 6, 8],
                 [3, 5, 7, 9],
                 [4, 6, 8, 10]]
    ok m?, 'If have a known matrix, m = [[1,2,3,4],[3,4,5,6],[5,6,7,8],[7,8,9,10]], and call "mT = Matrix4x4.Transpose(m),"' 
    mT = Matrix4x4.Transpose(m)
    for i in [0..3]
      for j in [0..3]
        equal mT.m[i][j], mExpected[i][j], "mT[#{i}][#{j}] is expected to be equal to #{mExpected[i][j]},"
    
    
  test 'Test getting an Inverse with Matrix.Inverse:', ->
    ok Matrix4x4?, 'If we create an identity matrix by calling "identity = new Matrix4x4" with no arguments'
    identity = new Matrix4x4()
    inv = Matrix4x4.Inverse(identity)
    ok inv?, 'and call "inv = Matrix4x4.Inverse(identity)"'
    ok Matrix4x4.IsIdentity(inv), 'the result should also be an identity matrix.'
    singular = new Matrix4x4([[1,    2,   3, 4],
                              [1.5, -2.5, 4, 9],
                              [0,    0,   0, 0],
                              [4,   -2,   1, 1]])
    ok singular?, 'If have a known singular matrix, singluar = [[1,2,3,4],[1.5,-2.5,4,9],[0,0,0,0],[4,-2,1,1]], and call "inv = Matrix4x4.Inverse(singular),"' 
    raises ->
        inv = Matrix4x4.Inverse(singular)
      , /Singular matrix has no inverse/, 'a MatrixInverseError is thrown: "Singular Matrix has no Inverse"'
    m = new Matrix4x4([[0,4,0,-3],
                       [1,1,5,2],
                       [1,-2,0,6],
                       [3,0,0,1]])
    ok m?, 'If have a known non-singular matrix, m = [[0,4,0,-3],[1,1,5,2],[1,-2,0,6],[3,0,0,1]], and call "inv = Matrix4x4.Inverse(m),"' 
    inv = Matrix4x4.Inverse(m)
    result = [[-0.04,  0,   -0.08,   0.36],
              [0.34,   0,    0.18,  -0.06],
              [-0.108, 0.2, -0.116, -0.028],
              [0.12,   0,    0.24,  -0.08]]
    for i in [0..3]
      for j in [0..3]
        equalWithin(inv.m[i][j], result[i][j], 15, "inv[#{i}][#{j}] is expected to be result[#{i}][#{j}]")