// component to draw a tank sprite - a composite sprite build from few parts

TankSpriteComponent = class extends Component
//// constructor
  // @hullSprite:string - name of sprita that will be used as hull
  // @gunSprite:string - name of sprite that will be used as gun
  // @trackSprite:string - name of sprite that will be used as tracks
  // @trackOffset:number - offset by which tracks will be moved away from hull
  constructor = function(hullSprite, gunSprite, trackSprite, trackOffset)
    super()
    
    this.HullSprite = hullSprite
    this.GunSprite = gunSprite
    this.TrackSprite = trackSprite
    Size = 16 // sprite's size in pixels
    this.TrackOffset = trackOffset // offset used for tracks to draw them on both sides of the tank's hull
  end
  
//// Draw - Draw component on particular layer
  // @layer:int - currently drawn layer
  Draw = function(layer)
    if layer == 2 then
      local transform = Owner.Transform
      
      screen.setDrawRotation(transform.Rotation) // -90 because all tank sprites are facing up while 0 degree in engine is right
      
      // a vecotr used to follow entity's rotation, used as pivot for drawing tracks on both sides of the hull
      local vOffset = new Vector2D(0, TrackOffset)
      vOffset.RotateByAngle(transform.Rotation)
      
      // draw tracks. When entity is moving, draw animated sprites. Otherwise draw just 1'st (0 index) frame as static sprite
      if transform.IsMoving then
        screen.drawSprite(TrackSprite, transform.Position.X + vOffset.X, transform.Position.Y + vOffset.Y, Size, Size)
        screen.drawSprite(TrackSprite, transform.Position.X - vOffset.X, transform.Position.Y - vOffset.Y, Size, Size)
      else
        screen.drawSprite(TrackSprite + ".0", transform.Position.X + vOffset.X, transform.Position.Y + vOffset.Y, Size, Size)
        screen.drawSprite(TrackSprite + ".0", transform.Position.X - vOffset.X, transform.Position.Y - vOffset.Y, Size, Size)
      end
      
      // draw hull and gun
      screen.drawSprite(HullSprite, transform.Position.X, transform.Position.Y, Size, Size)
      screen.drawSprite(GunSprite, transform.Position.X, transform.Position.Y, Size, Size)
      
      screen.setDrawRotation(0) // reset drawing rotation
    end
  end
end