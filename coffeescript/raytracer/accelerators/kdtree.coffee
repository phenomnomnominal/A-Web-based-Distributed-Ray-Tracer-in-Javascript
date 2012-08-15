class KdTree extends Aggregate
  constructor: (primitives, @intersectionCost = 80, @traversalCost = 1, @emptyBonus = 0.5, @maxPrimitives = 1, @maxDepth= -1) ->
    super()
    @primitives = []
    debugger
    for p in primitives
      @primitives.concat p.fullyRefine()
    @nextFreeNode = @numberNodes = 0
    @nextFreeNode++
    if @maxDepth <= 0
      @maxDepth = Math.round(8 + 1.3 * (Math.log(@primitives.length) / Math.LN2))
    primitiveBounds = []
    bounds = new BoundingBox()
    for i in [0...@primitives.length]
      b = @primitives[i].worldBound()
      bounds = BoundingBox.UnionBBoxAndBBox(bounds, b)
      primitiveBounds.push b
    edges = [[],[],[]]
    prims0 = []
    prims1 = []
    primitiveNums = (i for i in [0...@primitives.length])
    @nodes = []
    this.buildTree(0, bounds, primitiveBounds, primitiveNums, @primitives.length, maxDepth, edges, prims0, prims1)
    
  buildTree: (nodeNumber, nodeBounds, allPrimitiveBounds, primitiveNums, numberOfPrimitives, depth, edges, prims0, prims1, badRefines) ->
    if numberOfPrimitives <= @maxPrimitives || depth is 0
      @nodes[nodeNum] = new KdTreeNode()
      @nodes[nodeNum].initLeaf(primitiveNums, numberOfPrimitives)
      return
    bestAxis = -1
    bestOffset = -1
    bestCost = Infinity
    oldcost = @intersectionCost * numberOfPrimitives
    totalSurfaceArea = nodeBounds.SurfaceArea();
    invTSA = 1 / totalSurfaceArea
    d = Vector.SubtractPointFromPoint nodeBounds.pMax, nodeBound.pMin
    axis = nodeBounds.MaximumExtent()
    retries = 0
    found = false
    while not found and retries < 3
      for i in [0...numberOfPrimitives]
        pn = primitiveNums[i]
        bbox = allPrimitiveBounds[i]
        edges[axis][2*i] = new BoundEdge(bbox.pMin[axis], pn, true)
        edges[axis][2*i + 1] = new BoundEdge(bbox.pMax[axis], pn, false)
      sortFunc = (a, b) ->
        if a.t < b.t
          return -1
        if a.t > b.t
          return 1
        if a.t is b.t
          if a.starting and not b.starting
            return -1
          if b.starting and not a.starting
            return 1
          else 
            return 0
      edges.sort(sortFunc)
      nBelow = 0
      nAbove = numberOfPrimitives
      for i in [0...2*numberOfPrimitives]
        if not edges[axis][i].starting
          nAbove--
        edgeT = edges[axis][i].t 
        if edgeT > nodeBounds.pMin[axis] and edgeT < nodeBouds.pMax[axis]
          otherAxis0 = (axis + 1) % 3
          otherAxis1 = (axis + 2) % 3
          belowSurfaceArea = 2 * (d[otherAxis0] * d[otherAxis1] +
                                  (edgeT - nodeBounds.pMin[axis]) *
                                  (d[otherAxis0] + d[otherAsix1]))
          aboveSurfaceArea = 2 * (d[otherAxis0] * d[otherAxis1] +
                                  (nodeBounds.pMax[axis] - edgeT) *
                                  (d[otherAxis0] + d[otherAsix1]))
          pBelow = belowSurfaceArea * invTSA
          pAbove = aboveSurfaceArea * invTSA
          eb = if nAbove is 0 or nBelow is 0 then @emptyBonus else 0
          cost = @traversalCost + @intersectionCost * (1 - eb) * (pBelow * nBelow + pAbove * nAbove)
          if cost < bestCost
            bestCost = cost
            bestAxis = axis
            bestOffset = i
            found = true
        if edges[axis][i].starting
          nBelow++
      if bestAxis is -1 and retries < 2
        retries++
        axis = axis + 1 % 3
    if bestCost > oldCost
      badRefines++
    if (bestCost > 4 * oldCost and numberOfPrimitves < 16) or bestAxis is -1 or badRefines is 3
      @nodes[nodeNum] = new KdTreeNode()
      @nodes[nodeNum].initLeaf(primitiveNums, numberOfPrimitives)
      return
    n0 = 0
    n1 = 0
    for i in [0...bestOffset]
      if edges[bestAxis][i].starting
        prims0[n0++] = edges[bestAxis][i].primNum
    for i in [bestOffset + 1...2 * numberOfPrimitives]
      if not edges[bestAxis][i].starting
        prims1[n1++] = edges[bestAxis][i].primNum
    tSplit = edges[bestAxis][bestOffset].t
    bounds0 = nodeBounds
    bounds1 = nodeBounds
    bounds0.pMax[bestAxis] = bounds1.pMin[bestAxis] = tSplit
    buildTree(nodeNum + 1, bounds0, allPrimitiveBounds, prims0, n0, depth - 1, edges, prims0, prims1 + numberOfPrimitives, badRefines)
    aboveChild = nextFreeNode
    @nodes[nodeNum] = new KdTreeNode()
    @nodes[nodeNum].initInterior(bestAxis, aboveChild, tSplit)
    buildTree(aboveChild, bounds1, allPrimBounds, prims1, n1, depth - 1, edges, prims0, prims1 + numberOfPrimitives, badRefines)
    
  intersect: (ray) ->
    [intersects, tmin, tmax] = @bounds.intersectP r
    if not intersects then return no
    invDirection = new Vector(1 / ray.d.x, 1 / ray.d.y, 1 / ray.d.z)
    todoPosition = 0
    todo = []
    hit = false
    node = @nodes[0]
    while node?
      if ray.maxTime < tmin
        break
      if node.isLeaf()
        axis = node.splitAxis()
        tplane = (node.splitPosition() - ray.o[axis]) * invDirection[axis]
        belowFirst = (ray.o[axis] < node.splitPosition() || 
                      ray.o[axis] is node.splitPosition() and ray.d[axis] >= 0)
        if belowFirst
          firstChild = node + 1
          secondChild = @nodes[node.aboveChild()]
        else
          firstChild = @nodes[node.aboveChild()]
          secondChild = node + 1
        if tplane > tmax or tplane <= 0
          node = firstChild
        else if tplane < tmin
          node = secondChild
        else
          todo[todoPosition] = new KdToDO(secondChild, tplane, tmax)
          todoPosition++
      else
        nPrimitives = node.numberOfPrimitives
        if nPrimitives is 1
          prim = @primitives[node.onePrimitive]
          [intersects, intersection, r] = prim.intersect(ray)
          if intersects
            hit = true
        else
          prims = node.primitives
          for i in [0...prims.length]
            prim = @primitives[prims[i]]
            [intersects, intersection, r] = prim.intersect(ray)
            if intersects
              hit = true
        if todoPosition > 0
          todoPoisition--
          node = todo[todoPosition].node
          tmin = todo[todoPosition].tmin
          tmax = todo[todoPosition].tmax
        else
          break
    return hit
    
class KdToDo
  constructor: (@node, @tmin, @tmax) ->

class BoundEdge
  constructor: (@t, @primNum, @starting) ->

class KdTreeNode
  constructor: ->
    
  initLeaf: (primNums, @numberOfPrimitives) ->
    @flags = 3
    if numberOfPrimitives is 0
      @onePrimitive = 0
    if numberOfPrimitives is 1
      @onePrimitive = primNums[0]
    else
      @primitives = []
      for i in [0...numberOfPrimitives]
        @primitives[i] = primNums[i]
    
  initInterior: (axis, @aboveChild, @split) ->
    @flags = axis
    
  splitPosition: ->
    @split
  
  numberPrimitives: ->
    @numberPrimitives
  
  splitAxis: ->
    @flags & 3
    
  isLeaf: ->
    @flags & 3 is 3
  
  aboveChild: ->
    @aboveChild
    
root = exports ? this
root.KdTree = KdTree