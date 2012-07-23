# *matrix.coffee* contains the **`Matrix4x4`** class.
# ___

# ## <section id='matrix'>Matrix4x4:</section>
# ___

# The **`Matrix4x4`** class provides a low-level representation of 4 x 4 Matrices.
class Matrix4x4
  # ### *constructor:*
  # >The constructor function takes an `Array[4][4]` as a representation of the matrix, and if any value is `undefined` then it is set to the corresponding value from the identity matrix:
  # >> `[1, 0, 0, 0]`  
  # >> `[0, 1, 0, 0]`  
  # >> `[0, 0, 1, 0]`  
  # >> `[0, 0, 0, 1]`  
  constructor: (matrix) ->
    @m = [[],[],[],[]]
    @m[0][0] = if matrix? and matrix[0]? and matrix[0][0]? then matrix[0][0] else 1 
    @m[0][1] = if matrix? and matrix[0]? and matrix[0][1]? then matrix[0][1] else 0
    @m[0][2] = if matrix? and matrix[0]? and matrix[0][2]? then matrix[0][2] else 0
    @m[0][3] = if matrix? and matrix[0]? and matrix[0][3]? then matrix[0][3] else 0
    @m[1][0] = if matrix? and matrix[1]? and matrix[1][0]? then matrix[1][0] else 0
    @m[1][1] = if matrix? and matrix[1]? and matrix[1][1]? then matrix[1][1] else 1
    @m[1][2] = if matrix? and matrix[1]? and matrix[1][2]? then matrix[1][2] else 0
    @m[1][3] = if matrix? and matrix[1]? and matrix[1][3]? then matrix[1][3] else 0
    @m[2][0] = if matrix? and matrix[2]? and matrix[2][0]? then matrix[2][0] else 0
    @m[2][1] = if matrix? and matrix[2]? and matrix[2][1]? then matrix[2][1] else 0
    @m[2][2] = if matrix? and matrix[2]? and matrix[2][2]? then matrix[2][2] else 1
    @m[2][3] = if matrix? and matrix[2]? and matrix[2][3]? then matrix[2][3] else 0
    @m[3][0] = if matrix? and matrix[3]? and matrix[3][0]? then matrix[3][0] else 0
    @m[3][1] = if matrix? and matrix[3]? and matrix[3][1]? then matrix[3][1] else 0
    @m[3][2] = if matrix? and matrix[3]? and matrix[3][2]? then matrix[3][2] else 0
    @m[3][3] = if matrix? and matrix[3]? and matrix[3][3]? then matrix[3][3] else 1
    
    # ___  
    # ### Prototypical Instance Functions:

    # These functions are attached to each instance of the **`Matrix4x4`** class - changing the function of one **`Matrix4x4`** changes the function on all other **`Matrix4x4`**s as well. These functions act on a **`Matrix4x4`** instance in place - the original object is modified.
  
  # ### *equals:*
  # > **`equals`** checks a **`Matrix4x4`** for equality with another **`Matrix4x4`**. Two **Matrix4x4** instances are equal if each of their components are all the same.
  equals: (m) ->
    if m.constructor? and m.constructor.name is "Matrix4x4"
      for i in [0..3]
        for j in [0..3]
          if @m[i][j] isnt m.m[i][j] then return false;
      return true
    return false
    
  # ___  
  # ### Static Functions:

  # These functions belong to the **`Matrix4x4`** class - any object arguments are not 
  # modified and a new object is always returned.

  # ### *Matrix4x4.Equals:*
  # > **`Matrix4x4.Equals`** checks a **`Matrix4x4`** for equality with another **`Matrix4x4`**. Two **`Matrix4x4`** instances are equal if each of their components are all the same.
  @Equals: (m1, m2) ->
    if m1.constructor? and m1.constructor.name is "Matrix4x4" and m2.constructor? and m2.constructor.name is "Matrix4x4"
      for i in [0..3]
        for j in [0..3]
          if m1.m[i][j] isnt m2.m[i][j] then return false;
      return true
    return false
  
  # ### *Matrix.IsIdentity:*
  # > **`Matrix.IsIdentity`** checks if a given **`Matrix4x4`** is an identity matrix.
  @IsIdentity: (m) ->
    return m.m[0][0] is 1 and m.m[0][1] is 0 and m.m[0][2] is 0 and m.m[0][3] is 0 and
           m.m[1][0] is 0 and m.m[1][1] is 1 and m.m[1][2] is 0 and m.m[1][3] is 0 and
           m.m[2][0] is 0 and m.m[2][1] is 0 and m.m[2][2] is 1 and m.m[2][3] is 0 and
           m.m[3][0] is 0 and m.m[3][1] is 0 and m.m[3][2] is 0 and m.m[3][3] is 1
    
  
  # ### *Matrix.Multiply:*
  # > **`Matrix.Multiply`** multiplies any number of **`Matrxi4x4`** together.
  @Multiply: (m1, m2, mn...) ->
    mul = [[],[],[],[]]
    for i in [0..3]
      for j in [0..3]
        mul[i][j] = m1.m[i][0] * m2.m[0][j] +
                    m1.m[i][1] * m2.m[1][j] +
                    m1.m[i][2] * m2.m[2][j] +
                    m1.m[i][3] * m2.m[3][j]
    for matrix in mn
      mul = Matrix4x4.Multiply(new Matrix4x4(mul), matrix).m
    return new Matrix4x4(mul)

  # ### *Matrix.Transpose:*
  # > **`Matrix.Transpose`** performs the [**Transpose**](http://en.wikipedia.org/wiki/Transpose) operation - swap rows and columns - on a **`Matrix4x4`**.
  @Transpose: (m) ->
    return new Matrix4x4([[m.m[0][0], m.m[1][0], m.m[2][0], m.m[3][0]],
                          [m.m[0][1], m.m[1][1], m.m[2][1], m.m[3][1]],
                          [m.m[0][2], m.m[1][2], m.m[2][2], m.m[3][2]],
                          [m.m[0][3], m.m[1][3], m.m[2][3], m.m[3][3]]])
    
  # ### <section id='matrix-inverse'>*Matrix.Inverse:*</section>
  # > **`Matrix.Inverse`** performs [**Gauss-Jordan elimination**](http://en.wikipedia.org/wiki/Gauss%E2%80%93Jordan_elimination) on a **`Matrix4x4`** to compute the inverse.
  @Inverse: (m) ->
    indxc = []
    indxr = []
    ipiv = [0,0,0,0]
    minv = [[],[],[],[]]
    for copyRow in [0...4]
      for copyColumn in [0...4]
        minv[copyRow][copyColumn] = m.m[copyRow][copyColumn]
    for i in [0...4]
      irow = -1
      icol = -1
      big = 0
      for j in [0...4]
        if ipiv[j] isnt 1
          for k in [0...4]
            if ipiv[k] is 0
              if Math.abs(minv[j][k]) >= big
                big = Math.abs minv[j][k]
                irow = j
                icol = k
            else if ipiv[k] > 1
              throw Error "Singular matrix in MatrixInvert"
      ipiv[icol]++
      if irow isnt icol
        for k in [0...4]
          c = minv[irow][k]
          minv[irow][k] = minv[icol][k]
          minv[icol][k] = c
      indxr[i] = irow
      indxc[i] = icol
      if minv[icol][icol] is 0
        throw Error "Singular matrix in MatrixInvert"
      pivinv = 1 / minv[icol][icol]
      minv[icol][icol] = 1
      for j in [0...4]
        minv[icol][j] *= pivinv
      for j in [0...4]
        if j isnt icol
          save = minv[j][icol]
          minv[j][icol] = 0
          for k in [0...4]
            minv[j][k] -= minv[icol][k] * save
    for j in [3..0]
      if indxr[j] isnt indxc[j]
        for k in [0...4]
          c = minv[k][indxr[j]]
          minv[k][indxr[j]] = minv[k][indxc[j]]
          minv[k][indxc[j]] = c
    return new Matrix4x4(minv)   
    
# ___
# ## Exports:

# The [**`Matrix4x4`**](#matrix) class is added to the global `root` object.
root = exports ? this
root.Matrix4x4 = Matrix4x4