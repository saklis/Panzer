// component that stores position and rotation of entity

TransformComponent = class extends Component
//// constructor
  // @posX:number - X axist of position coords
  // @posY:number - Y axis of position coords
  // @rot:number - rotation from x axis in angles
  // @scaleX:number - scale factor on X axis
  // @scaleY:number - scale factor on Y axis
  constructor = function(posX = 0, posY = 0, rot = 0, scaleX = 1, scaleY = 1)
    super()
    
    Position = new Vector2D(posX, posY)
    Rotation = rot
    Scale = new Vector2D(scaleX, scaleY)
    
    IsMoving = false // is entity moving?
    MovementDirection = new Vector2D(0, 0)
  end
end