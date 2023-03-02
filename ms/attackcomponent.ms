// Component that adds function of attacking to entity

AttackComponent = class extends Component
  
  //// constructor
    // @projectileType:int - database ID for projectile that should be spawned
    // @damage:number - amount of damage delt
    // @projectileSpeed:number - speed at which projectile moves
    // @cooldown:number - cooldown in seconds
    constructor = function(projectileType = 0, damage = 10, projectileSpeed = 1, cooldown = 5)
    super()
    
    // Amount of damage delt on hit
    this.Damage = damage
    
    // Speed at which projectile moves
    this.ProjectileSpeed = projectileSpeed
    
    // Attack's cooldown in seconds. Next attack won't be possible for this ammount of time
    this.Cooldown = cooldown
    
    // Database ID for projectile that should be spawned
    this.ProjectileType = projectileType
    
    //Timer used to measure attack's cooldown
    CooldownTimer = 0
  end

//// CanAttack - Check if attack is possible
  // @return:bool - True if this component can attack now
  CanAttack = function()
    return CooldownTimer == 0
  end
  
//// Attack - perform attack
  Attack = function()
    if (CanAttack()) then
      local transform = Owner.Transform
      
      Fire(transform.Position.X, transform.Position.Y, transform.Rotation)
    end
  end
  
//// AttackTarget - Performs attack in the direction of target entity
  // @targetEntity:Entity - reference to entity that will be attacked
  AttackTarget = function(targetEntity)
    if (CanAttack()) then
      local transform = Owner.Transform
      // look at enemy - turns Owner to "look at" target
      local targetPosition = targetEntity.Transform.Position
      transform.Rotation = targetPosition.Subtract(transform.Position).ToAngle()
      
      Fire(transform.Position.X, transform.Position.Y, transform.Rotation)
    end
  end

//// Fire - for internal use. Executes attack
  // @posX:number - position of projectile spawnpoint on x axis
  // @posY:number - position of projectile spawnpoint on y axis
  // @rot:number - angle at wich projectile will be fired
  Fire = function(posX, posY, rot)
    pos = new Vector2D(posX, posY)
    effectPos = new Vector2D(15, 0)
    effectPos.RotateByAngle(rot)
    pos = pos.Add(effectPos)
    
    local projectileData = Database.ProjectileTypes[ProjectileType]
    
    // effects
    Game.SpawnEffect("muzzle_explo", pos.X, pos.Y, 32, 32, rot, 1.1)
    Noise.ProjectileFired(projectileData.Sound)
    
    local projectile = new Entity("projectile")
    projectile.AddComponent(new TransformComponent(pos.X, pos.Y, rot))
    projectile.AddComponent(new ProjectileControllerComponent(Owner, Damage, ProjectileSpeed))
    projectile.AddComponent(new SpriteComponent(projectileData.Sprite, 2, projectileData.SpriteSizeX, projectileData.SpriteSizeY))
    projectile.AddComponent(new CollisionComponent("PROJECTILE", pos.X, pos.Y, projectileData.CollisionSizeX, projectileData.CollisionSizeY, true, true))
    Owner.Game.Spawn(projectile)
    CooldownTimer = 0.00001 // start cooldown timer to mark that attack is on cooldown
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    if CooldownTimer >= Cooldown then CooldownTimer = 0 // if CooldownTimer is bigger than cooldown, reset timer ending the cooldown
    elsif CooldownTimer > 0 then CooldownTimer += deltaTime end // otherwise, if CooldownTimer is started, increase it by deltaTime
  end
end