// component controlls Entity based on player input

PlayerControllerComponent = class extends Component
//// constructor
  // @playerNumber:int - number of player that uses this controller. Used to identify input device. Allowed values <1,2>
  // @moveSpeed:number - speed of movement for player
  constructor = function(playerNumber, moveSpeed)
    super()
    
    this.PlayerNumber = playerNumber
    this.MoveSpeed = moveSpeed
    
    // reference to input device object
    this.PlayerInput = 0
    if PlayerNumber == 1 then PlayerInput = Input.Player1 end
    if PlayerNumber == 2 then PlayerInput = Input.Player2 end
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    local movement = new Vector2D(0, 0) // movement for this update
    
    // read input
    if PlayerInput.Up then
      movement.Y += 1
    end
    if PlayerInput.Down then
      movement.Y -= 1
    end
    if PlayerInput.Left then
      movement.X -= 1
    end
    if PlayerInput.Right then
      movement.X += 1
    end
    if PlayerInput.FireBegin then
      Owner.GetComponent(AttackComponent).Attack()
    end
    if PlayerInput.MenuBegin then
      PauseGame() // global function defined in main.ms
    end
    
    local transform = Owner.Transform
    
    if movement.GetLength() > 0 then
      transform.IsMoving = true
      
      // normalize movement vector for corect diagonal speed
      normalized = movement.GetNormalized()
      
      transform.MovementDirection = normalized
      // apply movement to entity's transform
      transform.Position.X += normalized.X * MoveSpeed
      transform.Position.Y += normalized.Y * MoveSpeed
      transform.Rotation = normalized.ToAngle()
    else
      transform.IsMoving = false
    end
  end
end