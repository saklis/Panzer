// component controlls entity to behave like a projectile

ProjectileControllerComponent = class extends Component
//// constructor
  // @instigator:Entity - entity that created this projectile
  // @damage:number - amount of damage delt on hit
  // @moveSpeed:number - speed at wich the projectile moves
  constructor = function(instigator, damage, moveSpeed)
    super()
    
    // entity which fired this projectile
    this.Instigator = instigator
    
    // amount of damage delt on hit
    this.Damage = damage
    
    // projectile's movement speed
    this.MoveSpeed = moveSpeed
    // projectile's movement direction. Calculated in init()
    MoveDirection = 0
  end
  
//// Init - Initialize component's members
  Init = function()
    local transform = Owner.Transform
    
    MoveDirection = new Vector2D(1,0)
    MoveDirection.RotateByAngle(transform.Rotation)
    MoveDirection = MoveDirection.GetNormalized()
    
    transform.MovementDirection = MoveDirection
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    local transform = Owner.Transform
    
    // apply movement to entity's transform
    transform.Position.X += MoveDirection.X * MoveSpeed
    transform.Position.Y += MoveDirection.Y * MoveSpeed
  end
end