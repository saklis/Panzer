// relation between CollisionComponent and collider that it created
CollisionTuple = class
//// constructor
  // @component:CollisionComponent - reference to component handling collisions for entity in game world
  // @collider:Matter.Body.Rectangle - refeerence to Matter.Body.Rectangle that represents colliders in physics engine
  constructor = function(component, collider)
    this.Component = component
    this.Collider = collider
  end
end

// relation between Enemy Entity's unique id and VectorField to that enemy
EnemyVectorFieldTuple = class
//// constructor
  // @enemyId:int - unique entity id of an Enemy
  // @vectorField:Vector2D[][] - 2D list of vectors
  constructor = function(enemyId, vectorField)
    this.EnemyId = enemy
    this.VectorField = vectorField
  end
end