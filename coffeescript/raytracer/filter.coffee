class Filter
  constructor: (@xWidth, @yWidth) ->
    @invXWidth = 1 / @xWidth
    @invYWidht = 1 / @yWidth
    
  evaluate: ->
    
class BoxFilter extends Filter
  constructor: (xWidth, yWidth) ->
    super(xWidth, yWidth)
    
  evaluate: ->
    1
    
class TriangleFilter extends Filter
  constructor: (xWidth, yWidth) ->
    super(xWidth, yWidth)
    
  evaluate: (x, y) ->
    xPart = Math.max 0, @xWidth - Math.abs(x)
    yPart = Math.max 0, @yWidth - Math.abs(y)
    xPart * yPart

class GaussianFilter extends Filter
  constructor: (xWidth, yWidth, @α) ->
    super(xWidth, yWidth)
    expX = Math.exp -@α * @xWidth * @xWidth
    expY = Math.exp -@α * @yWidth * @yWidth
  
  evaluate: (x, y) ->
    @gaussian(x, @expX) * @gaussian(y, @expY)
    
  gaussian: (d, exp) ->
    Math.max 0, Math.exp(-@α * d * d) - exp
    
class MitchellFilter extends Filter
  constructor: (@B, @C, xWidth, yWidth) ->
    super(xWidth, yWidth)
    
  evaluate: (x, y) ->
    @mitchell(x * @invXWidth) * mitchell(y * @invYWidth)
    
  mitchell: (x) ->
    x = Math.abs 2 * x
    if x > 1
      return ((-@B - 6 * @C) * x * x * x + (6 * @B + 30 * @C) * x * x +
              (-12 * @B - 48 * @C) * x + (8 * @B + 24 * @C)) * (1 / 6)
    else
      return ((12 - 9 * @B - 6 * @C) * x * x * x + (-18 + 12 * @B + 6 * @C) +
              x * x + (6 - 2 * @B)) * (1 / 6)
              
class LanczosSincFilter extends Filter
  constructor: (xWidth, yWidth, @τ) ->
    super(xWidth, yWidth)
    
  evaluate: (x, y) ->
    sinc(x * @invXWidth) * sinc(y * @invYWidth)
    
  sinc: (x) ->
    x = Math.abs x
    if x < 0.00001
      return 1
    if x > 1
      return 0
    xπ = x * Math.PI
    xπτ = xπ * @τ
    sincV = Math.sin(xπτ) / xπτ
    lanczos = Math.sin(xπ) / xπ
    sincV * lanczos