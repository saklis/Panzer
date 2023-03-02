// holds logic for upgrading player tank

UpgradeComponent = class extends Component
  //// constructor
  constructor = function(currentLevel)
    super()
    
    this.CurrentLevel = currentLevel
  end
  
//// Upgrade - upgrades owner to another level
  Upgrade = function()
    if Database.PlayerTanks.length > CurrentLevel + 1 then
      local data = Database.PlayerTanks[CurrentLevel + 1]
      
      local tankSprite = Owner.GetComponent(TankSpriteComponent)
      if Game.Player1 == Owner then
        tankSprite.HullSprite = data.HullSpriteP1
        tankSprite.GunSprite = data.GunSpriteP1
      elsif Game.Player2 == Owner then
        tankSprite.HullSprite = data.HullSpriteP2
        tankSprite.GunSprite = data.GunSpriteP2
      end
      tankSprite.TrackSprite = data.TrackSprite
      tankSprite.TrackOffset = data.TrackOffset
        
      local playerController = Owner.GetComponent(PlayerControllerComponent)
      playerController.MoveSpeed = data.MoveSpeed
        
      local attack = Owner.GetComponent(AttackComponent)
      attack.ProjectileType = data.ProjectileType
      attack.AttackDamage = data.AttackDamage
      attack.ProjectileSpeed = data.ProjectileSpeed
      attack.Cooldown = data.Cooldown
        
      local health = Owner.GetComponent(HealthComponent)
      health.MaxHealth = data.MaxHealth
      
      CurrentLevel += 1
      
      // special effects
      Game.SpawnEffect("firework", Owner.Transform.Position.X, Owner.Transform.Position.Y, 60, 60, 0, 1.16)
      Sound.Upgrade()
    end
  end
end