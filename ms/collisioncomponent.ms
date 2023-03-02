// Component that adds a collider to Entity and interfaces with physics engine to notify about collisions

CollisionComponent = class extends Component
  
//// constructor
  // @colliderType:string - type of collider. Supported options: PLAYER, PROJECTILE, WALL, ENEMY, TRIGGER
  // @x:number - X component of coords where collider should be created
  // @y:number - Y component of coords where collider should be created
  // @width:number - Width of the collider
  // @height:number - Height of the collider
  // @movable:bool - Should collider follow Entity's Transform?
  // @notify:bool - Should component react to collisions with other objects?
  constructor = function(colliderType = "WALL", x = 0, y = 0, width = 16, height = 16, movable = false, notify = false)
    super()
    
    this.Position = new Vector2D(x, y)
    this.Width = width
    this.Height = height
    
    // collider type decides how this collider reacts to collision with other colliders
    this.ColliderType = colliderType
    // should this collision be notified that it collided with other collider?
    this.NotifyAboutCollisions = notify
    // is this collision moving?
    this.IsMovable = movable
  end
  
//// Init - Initialize component's members
  Init = function()
    // add component to physics engine and store reference to physics collider
    Collider = Owner.Game.Physics.AddCollision(this)
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    if IsMovable then
      local transform = Owner.Transform
      Game.Physics.SetTransform(Collider, transform)
    end
  end
  
//// Destroy - Destroy component and cleanup
  Destroy = function()
    // remove collider from physics engine
    Game.Physics.RemoveCollision(this)
  end
  
////CollidesWith - called by physics engine to inform this component about collisions that occured in last update.
  // Called every update on ongoing collisions. Called once for every other component, can be called multiple times per update.
  // @otherComponent:CollisionComponent - colliding Collision component
  // @collider:object - Matter object that descirbes collision
  CollidesWith = function(otherComponent, collider)
    local transform = Owner.Transform
    local otherTransform = otherComponent.Owner.Transform
    
    if ColliderType == "PLAYER" then
      if otherComponent.ColliderType == "WALL" or otherComponent.ColliderType == "WATER" then
        // bounce off away from wall
        // create vector that point away from the other collider
        local newPos = transform.Position.Subtract(otherTransform.Position)
        local moveSpeed = Owner.GetComponent(PlayerControllerComponent).MoveSpeed
        // shorten the vector, making 'bounce off' smaller
        // 12 was found by trial and error, to "feel" best
        newPos = newPos.Multiply(moveSpeed / 12)
        transform.Position.X += newPos.X
        transform.Position.Y += newPos.Y
      end
      if otherComponent.ColliderType == "PROJECTILE" then
        // bounce off away from projectile - simulates both recoil and reaction to getting hit
        // create vector that point away from the other collider
        local newPos = transform.Position.Subtract(otherTransform.Position)
        newPos = newPos.Multiply(0.3) // shorten the vector, making 'hit' smaller
        transform.Position.X += newPos.X
        transform.Position.Y += newPos.Y
      end
    end
    if ColliderType == "PROJECTILE" then
      // ignore owner and triggers
      local instigator = Owner.GetComponent(ProjectileControllerComponent).Instigator
      if instigator != otherComponent.Owner and otherComponent.ColliderType != "TRIGGER" and otherComponent.ColliderType != "WATER" then
        // if you can, deal damage to other component
        local otherHealth = otherComponent.Owner.GetComponent(HealthComponent)
        if otherHealth != 0 then 
          local damage = Owner.GetComponent(ProjectileControllerComponent).Damage
          local isDestroyed = otherHealth.DealDamage(damage, instigator)
          if not isDestroyed then
            // play projectile explosion effect on if other entity was not killed
            local rotation = random.nextInt(8) * 45 // random rotation of explosion's effect
            Game.SpawnEffect("projectile_explo", transform.Position.X, transform.Position.Y, 50, 50, rotation, 1.05)
            Noise.ProjectileExploded()
          end
        else
          // play projectile explosion effect on if other entity was not killed
          local rotation = random.nextInt(8) * 45 // random rotation of explosion's effect
          Game.SpawnEffect("projectile_explo", transform.Position.X, transform.Position.Y, 50, 50, rotation, 1.05)
          Noise.ProjectileExploded()
        end
        // destroy projectile
        Game.Destroy(Owner)
      end
    end
    if ColliderType == "TRIGGER" then
      // only entity that uses TRIGGER type are upgrade power ups
      local upgradeComp = otherComponent.Owner.GetComponent(UpgradeComponent)
      if upgradeComp != 0 then
        upgradeComp.Upgrade()
        Game.Destroy(Owner)
      end
    end
  end
end