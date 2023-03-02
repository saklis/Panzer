// component to draw a filled rectangle

RectComponent = class extends Component
//// constructor
  constructor = function(layer, width, height, color)
    super()
    
    this.Layer = layer
    this.Width = width
    this.Height = height
    this.Color = color
  end
  
//// Init - Initialize component's members
  Init = function()
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
  end
  
//// Draw - Draw component on particular layer
  // @layer:int - currently drawn layer
  Draw = function(layer)
    if this.Layer == layer then
      local position = Owner.Transform.Position
      screen.fillRect(position.X, position.Y, Width, Height, Color)
    end
  end
  
//// Destroy - Destroy component and cleanup
  Destroy = function()
  end
end