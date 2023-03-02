// component that handles health, damage and destruction of entity, along with visual representation

HealthComponent = class extends Component
//// constructor
  // @health:number - starting/max amount of health
  // @layer:int - layer on which health effects will be drawn
  constructor = function(health = 100, layer = 2)
    super()
    
    this.Health = health
    this.MaxHealth = health // start fully healed
    this.Layer = layer
    
    this.DamageSpriteRotation = 90 * random.nextInt(4)
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
    if Owner.Name.startsWith("map") then
    if this.Layer = layer then
        if Health < MaxHealth then
          local position = Owner.Transform.Position
          if Health > (MaxHealth/2) then
            // from 50% to 99% health
            screen.setDrawRotation(DamageSpriteRotation)
            screen.drawSprite("damage_01", position.X, position.Y, 16, 16)
            screen.setDrawRotation(0)
          elsif Health < (MaxHealth/2) then
            // under 50% health
            screen.setDrawRotation(DamageSpriteRotation)
            screen.drawSprite("damage_02", position.X, position.Y, 16, 16)
            screen.setDrawRotation(0)
          end
        end
      end
    end
  end
  
//// Destroy - Destroy component and cleanup
  Destroy = function()
  end
  
//// DealDamage - receives damage. Mostly called by external source on collision
  // @damageAmount:number - amount of damage received
  // @instigator:Entity - entity that fired the projectile that dealt damage
  // @returns:bool - true if entity was destroyed as a result of dealing damage
  DealDamage = function(damageAmount, instigator)
    Health -= damageAmount
    if Health <= 0 then
      Owner.Game.Destroy(Owner, instigator)
      return true
    end
    return false
  end
end