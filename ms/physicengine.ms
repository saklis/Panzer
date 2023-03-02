// Handles calls to Matter physics engine

PhysicEngine = class
//// constructor
  constructor = function()
    // Matter engine instance. Created in init()
    Engine = 0
    
    // CollisionTuple collection. Relation between Entitie's CollisionComponents and Matter.Body's Colliders
    Colliders = []
  end
  
//// GetComponent - find component related to supplied collider
  // @collider:Matter.Body - collider related to component that must be found
  // @returns:CollisionComponent - component related to supplied collider. Returns 0 if component was not found
  GetComponent = function(collider)
    for tuple in Colliders
      if tuple.Collider == collider then 
        return tuple.Component
      end
    end
    return 0
  end
  
//// Init - initialize physics engine
  Init = function()
    Engine = Matter.Engine.create()
    Engine.gravity.scale = 0 // disable gravity
    
    // subscribe to event
    Matter.Events.on(Engine, "collisionActive", OnCollisionActive)
  end
  
//// Update - update physics engine
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    Matter.Engine.update(Engine, 1000/60)
    // all Matter events are fired after each update - handled by callbacks set up in Init()
  end
  
//// AddCollision - create collider for supplied component and add it to physics simulation
  // @component:ColliderComponent - component to add to simulation
  // @returns:Matter.Body.Rectangle - Matter collider assigned to supplied component
  AddCollision = function(component)
    local newRect = Matter.Bodies.rectangle(component.Position.X, component.Position.Y, component.Width, component.Height, object isSensor = true isStatic = not component.IsMovable end)
    Matter.Composite.add(Engine.world, newRect)
    Colliders.push(new CollisionTuple(component, newRect))
    return newRect
  end
  
//// RemoveCollision - remove collider related to supplied component from physics simulation
  // @component:CollisionComponent - component related to collider that must be removed
  RemoveCollision = function(component)
    local removeAtIndex = -1
    for i = 0 to Colliders.length - 1
      if Colliders[i].Component == component then 
        removeAtIndex = i 
        break
      end
    end
  
    if removeAtIndex >= 0 then
      Matter.Composite.remove(Engine.world, Colliders[removeAtIndex].Collider)
      Colliders.removeAt(removeAtIndex)
    else
      print("ERROR: Removing Collision Component from " + Component.Owner.Name + " but it can't be found in physics components collection.")
    end
  end
  
//// SetTransform - set position and rotation of supplied collider
  // @collider:Matter.Body.Rectangle - collider that will have transform changed
  // @transformComponent:TransformComponent - component that holds information that will be used to change position and rotation
  SetTransform = function(collider, transformComponent)
    Matter.Body.setPosition(collider, object 
                                        x = transformComponent.Position.X
                                        y = transformComponent.Position.Y
    end)
    // setting rotation, while correct, was disabled because it makes the feel of the gameplay worse.
    // While approaching a wall at 45 degree angle tank stops, because the very corner of collision clips into the wall
    // keeping the colliders at 0 degree all the time causees slight overlap of sprites in those cases, but it's way less jaring that bouncing off corers of rotated collider
    //Matter.Body.setAngle(collider, transformComponent.Rotation/180*PI)
  end
  
//// Trace - returns list of components that are related to colliders that intersects line between supplied points
  // @startPoint:Vector2D - vector with coords of line's starting point
  // @endPoint:Vector2D - vector with coords of line's end point
  // @returns:CollisionComponent[] - All Components related to colliding colliders. List can be empty
  Trace = function(startPoint, endPoint)
    local collisions = Matter.Query.ray(Matter.Composite.allBodies(Engine.world), 
                                         object x=startPoint.X y=startPoint.Y end,
                                         object x=endPoint.X y=endPoint.Y end)
    local components = []
    for collision in collisions
      // both bodyA and bodyB are set to same collider in this case. Doesn't matter which one is passed to GetComponent()
      local component = GetComponent(collision.bodyA)
      if component.ColliderType != "TRIGGER" and component.ColliderType != "WATER" then // ignore TRIGGERS and WATER - those should not block line of fire
        components.push(component)
      end
    end
    return components
  end
  
//// TraceAiToTarget - special Trace used by AI Controller Component when attacking target. Ignores other Enemies
  // @startPoint:Vector2D - vector with coords of line's starting point
  // @endPoint:Vector2D - vector with coords of line's end point
  // @returns:CollisionComponent[] - All Components related to colliding colliders. List can be empty
  TraceAiToTarget = function(startPoint, endPoint)
    local collisions = Matter.Query.ray(Matter.Composite.allBodies(Engine.world), 
                                         object x=startPoint.X y=startPoint.Y end,
                                         object x=endPoint.X y=endPoint.Y end)
    local components = []
    for collision in collisions
      // both bodyA and bodyB are set to same collider in this case. Doesn't matter which one is passed to GetComponent()
      local component = GetComponent(collision.bodyA)
      if component.ColliderType != "ENEMY" and component.ColliderType != "TRIGGER" and component.ColliderType != "WATER" then // ignore TRIGGERS and WATER - those should not block line of fire
        components.push(component)
      end
    end
    return components
  end
  
//// OnCollisionActive - STATIC EVENT. Called by physics engine after each update for each pair of colliding bodies.
  // @event:object - Matter object with information about pair of colliding objects
  OnCollisionActive = function(event)
    local pairs = event.pairs
    for pair in pairs
      // call methods through global Game object, because it's not officially supported to invoke class members from Matter events
      local componentA = Game.Physics.GetComponent(pair.bodyA)
      local componentB = Game.Physics.GetComponent(pair.bodyB)
      
      if componentA != 0 and componentA.NotifyAboutCollisions then componentA.CollidesWith(componentB, pair.bodyA) end
      if componentB != 0 and componentB.NotifyAboutCollisions then componentB.CollidesWith(componentA, pair.bodyB) end
    end
  end
  
//// DEBUG_DrawColliders - draws all collider rectangles
  DEBUG_DrawColliders = function()
    for body in Matter.Composite.allBodies(Engine.world)
      local size = Matter.Vector.magnitude(Matter.Vector.sub(body.vertices[0], body.vertices[1]))
      local color = "rgb(0,0,255)"
      if not body.isStatic then color = "rgb(0,255,0)" end
      
      screen.setDrawRotation(body.angle/PI*180)
      screen.drawRect(body.position.x, body.position.y, size, size, color)
      screen.setDrawRotation(0)
    end
  end
end