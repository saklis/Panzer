// component to draw a single sprite

SpriteComponent = class extends Component
//// constructor
  // @spriteName:string - name of sprrite asset
  // @layer:int - layer on which sprite should be drawn
  // @width:number - width of drawn sprite
  // @height:number - height of drawn sprite
  // @lifetime:number - number of seconds after which Owner of this component should be destroyed automatically. If 0 then will never be destroyed
  constructor = function(spriteName, layer = 0, width = 16, height = 16, lifetime = 0)
    super()
    
    this.Sprite = spriteName
    this.Width = width
    this.Height = height
    this.Layer = layer
    
    this.Lifetime = lifetime
    this.LifetimeTimer = 0
    
    // variables used in animation
    this.FrameCount = sprites[Sprite].frames.length
    this.FrameTime = 1 / sprites[Sprite].fps
    this.FrameTimer = 0
    this.CurrentFrame = 0
  end
  
//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    // check if sprite is past its lifetime
    if Lifetime > 0 then
      LifetimeTimer += deltaTime
      if LifetimeTimer >= Lifetime then 
        Game.Destroy(Owner) 
      end
    end
    
    // handle animation if there's more than 1 frame
    if FrameCount > 1 then
      FrameTimer += deltaTime
      if FrameTimer >= FrameTime then
        CurrentFrame += 1
        if CurrentFrame >= FrameCount then CurrentFrame = 0 end
        FrameTimer = 0
      end
    end
  end
  
//// Draw - Draw component on particular layer
  // @layer:int - currently drawn layer
  Draw = function(layer)
    if this.Layer == layer then
      local transform = Owner.Transform
      screen.setDrawRotation(transform.Rotation)
      sprites[Sprite].setFrame(CurrentFrame)
      screen.drawSprite(Sprite, transform.Position.X, transform.Position.Y, Width, Height)
      screen.setDrawRotation(0)
    end
  end
end