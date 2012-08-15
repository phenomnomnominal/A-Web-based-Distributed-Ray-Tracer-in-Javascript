class InfiniteAreaLight extends Light
  constructor: (lightToWorld, @emitted, ns, texture) ->
    super(lightToWorld, ns)

root = exports ? this
root.InfiniteAreaLight = InfiniteAreaLight