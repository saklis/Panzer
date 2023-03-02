// A component that draws part of sprite

AssetSpriteComponent = class extends Component
  
//// constructor
  // @layer:int - layer number on which this sprite will be drawn
  // @partX:int - X component of coords used to locate part of the sprite
  // @partY:int - Y component of coords used to locate part of the sprite
  // @partWidth:int - width of the sprite part
  // @partHeight:int - heioght of the sprite part
  constructor = function(layer, partX, partY, partWidth, partHeight)
    super()
    
    // name of sprite
    Sprite = "assets"
    
    
    this.Layer = layer
    this.PartX = partX
    this.PartY = partY
    this.PartWidth = partWidth
    this.PartHeight = partHeight
  end
  
//// Draw - Draw component on particular layer
  // @layer:int - currently drawn layer
  Draw = function(layer)
    if this.Layer == layer then
      local transform = Owner.Transform
      
      screen.setDrawRotation(transform.Rotation)
      screen.setDrawScale(transform.Scale.X, transform.Scale.Y)
      
      screen.drawSpritePart(Sprite, PartX, PartY, PartWidth, PartHeight, transform.Position.X, transform.Position.Y, PartWidth, PartHeight)
      
      screen.setDrawRotation(0)
      screen.setDrawScale(1, 1)
    end
  end
end