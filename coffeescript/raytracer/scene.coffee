# *scene.coffee* contains the [**`Scene`**](#scene) class.
# ___

# ## Error Types:
# Some specific **`Error`** types for these classes:
  
# <section id='sce'></section>
#
# * **`SceneConstructorError`**:
#
# >> These errors are thrown when something is wrong in the [**`Scene`**](#scene) constructor
class SceneConstructorError extends Error

# ___

# ## <section id='scene'>Scene:</section>
# ___
# The **`Scene`** class is the object which contains the representation of everything in the scene.
class Scene
  # ### *constructor:*
  # > The **`Scene`** constructor requires three parameters:
  #
  # > * The single acceleration data structure for all the [**`Primitive`**](primitive.html#primitive) geometry in the **`Scene`**: `aggregate` - must be a **`Primitive`**
  #
  # > * An `Array` of all the [**`Lights`**] in the **`Scene`**: `lights`
  #
  # > * The single data structure for all volumetric primitives: `volumeRegion` - must be a [**`VolumeRegion`**]()
  #
  # > If the arguments are not supplied or are of the incorrect type, the constructor will throw a [**`SceneConstructorError`**](#sce).
  constructor: (@aggregate, @lights, @volumeRegion) ->
    unless @aggregate?
      throw SceneConstructorError 'aggregate must be defined.'
    unless @aggregate instanceof Primitive
      throw SceneConstructorError 'aggregate must be a Primitive.'
    unless @lights?
      throw SceneConstructorError 'lights must be defined.'
    unless _.isArray @lights
      throw SceneConstructorError 'lights must be an Array.'
    for l in @lights
      unless l instanceof Light
        throw SceneConstructorError 'lights must only contain Lights.'
    if @volumeRegion?
      unless @volumeRegion instanceof VolumeRegion
        throw SceneConstructorError 'volumeRegion must be a VolumeRegion.'
    
    @bound = @aggregate.worldBound()
    if @volumeRegion?
      @bound = BBox.UnionBBoxAndBBox bound, volumeRegion.worldBound()
      
  # ### *worldBound:*
  # > **`worldBound`** returns a [**`BoundingBox`**](geometry.html#bbox) that encompasses every object within the **`Scene`**.
  worldBound: ->
    return @bound
  
  # ### *intersect:*
  # > **`intersect`** returns geometric information about a single [**`Ray`**](geometry.html#ray)-**`Scene`** intersection corresponding to the first intersection (if any) along the parametric range of the **`Ray`**.
  intersect: (ray) ->
    [hit, intersection] = @acceleration.intersect ray
    return [hit, intersection]
  
  # ### *intersectP:*
  # > **`intersectP`** determines whether or not an intersection occurs between a **`Ray`** and the **`Scene`**, without providing any information about the intersection.
  intersectP: (ray) ->
    return @acceleration.intersecP ray

# ___
# ## Exports:

# The [**`Scene`**](#scene) class is added to the global `root` object.    
root = exports ? this
root.Scene = Scene