// Stores data and configuration for the game

Database = class
//// GetLevel - return level under index stored in Game.CurrentLevelIndex
  // @returns:object - current level
  GetLevel = function()
    return Levels[Game.CurrentLevelIndex]
  end
  
//// GetMapName - returns name of map for current level
  // @returns:string - name of map asset
  GetMapName = function()
    return Levels[Game.CurrentLevelIndex].MapName
  end
  
//// GetEnemiesPool - returns number of enemies for current level
  // @returns:int - size of enemies pool
  GetEnemiesPool = function()
    return Levels[Game.CurrentLevelIndex].EnemiesPool
  end
  
//// GetMaxEnemies - returns max number of concurrent enemies for current level
  // @return:int - max number of concurrent enemies
  GetMaxEnemies = function()
    return Levels[Game.CurrentLevelIndex].MaxEnemies
  end
  
//// GetEnemySpawnCooldown - returns cooldown in seconds between spawn of next enemy
  // @returns:number - number of seconds between enemies spawn
  GetEnemySpawnCooldown = function()
    return Levels[Game.CurrentLevelIndex].EnemySpawnCooldown
  end
  
//// GetEnemy - get random enemy for current level
  // @returns:object - enemy
  GetEnemy = function()
    local enemyCount = Levels[Game.CurrentLevelIndex].Enemies.length
    local index = Levels[Game.CurrentLevelIndex].Enemies[random.nextInt(enemyCount)]
    return EnemyTanks[index]
  end
  
//// GetUpgrades - returns a list of numbers representing enemies left count on which upgrades should be spawned
  // @returns:int[] - list of enemies left thresholds
  GetUpgrades = function()
    if Game.Player2 == 0 then
      return Levels[Game.CurrentLevelIndex].UpgradesP1
    else
      return Levels[Game.CurrentLevelIndex].UpgradesP2
    end
  end

//// Data /////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data is stored in for of arrays of objects

//// LEVELS ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  Levels = [
    // LEVEL 0
    object
      MapName = "level_01"
      EnemiesPool = 10
      MaxEnemies = 3
      EnemySpawnCooldown = 5
      Enemies = [0]
      UpgradesP1 = [] // upgrades spawn for 1 player game mode
      UpgradesP2 = [] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 1
    object
      MapName = "level_02"
      EnemiesPool = 15
      MaxEnemies = 3
      EnemySpawnCooldown = 3
      Enemies = [0]
      UpgradesP1 = [] // upgrades spawn for 1 player game mode
      UpgradesP2 = [] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 2
    object
      MapName = "level_03"
      EnemiesPool = 20
      MaxEnemies = 4
      EnemySpawnCooldown = 3
      Enemies = [0, 1]
      UpgradesP1 = [] // upgrades spawn for 1 player game mode
      UpgradesP2 = [] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 3
    object
      MapName = "level_04"
      EnemiesPool = 20
      MaxEnemies = 4
      EnemySpawnCooldown = 3
      Enemies = [0, 1]
      UpgradesP1 = [15] // upgrades spawn for 1 player game mode
      UpgradesP2 = [15,14] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 4
    object
      MapName = "level_05"
      EnemiesPool = 25
      MaxEnemies = 5
      EnemySpawnCooldown = 2.5
      Enemies = [0, 1]
      UpgradesP1 = [17] // upgrades spawn for 1 player game mode
      UpgradesP2 = [17,16] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 5
    object
      MapName = "level_06"
      EnemiesPool = 25
      MaxEnemies = 4
      EnemySpawnCooldown = 3
      Enemies = [0, 1, 2]
      UpgradesP1 = [15] // upgrades spawn for 1 player game mode
      UpgradesP2 = [15,14] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 6
    object
      MapName = "level_07"
      EnemiesPool = 30
      MaxEnemies = 5
      EnemySpawnCooldown = 2
      Enemies = [0, 1]
      UpgradesP1 = [20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [20,19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 7
    object
      MapName = "level_08"
      EnemiesPool = 30
      MaxEnemies = 4
      EnemySpawnCooldown = 2.5
      Enemies = [0, 1]
      UpgradesP1 = [20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [20,19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 8
    object
      MapName = "level_09"
      EnemiesPool = 30
      MaxEnemies = 4
      EnemySpawnCooldown = 2.5
      Enemies = [0, 1]
      UpgradesP1 = [20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [20,19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 9
    object
      MapName = "level_10"
      EnemiesPool = 30
      MaxEnemies = 6
      EnemySpawnCooldown = 2
      Enemies = [1, 2]
      UpgradesP1 = [20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [20,19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 10
    object
      MapName = "level_11"
      EnemiesPool = 20
      MaxEnemies = 4
      EnemySpawnCooldown = 2
      Enemies = [1, 3]
      UpgradesP1 = [15, 10] // upgrades spawn for 1 player game mode
      UpgradesP2 = [15, 14, 10, 9] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 11
    object
      MapName = "level_12"
      EnemiesPool = 20
      MaxEnemies = 4
      EnemySpawnCooldown = 2.5
      Enemies = [3, 4]
      UpgradesP1 = [17, 12, 5] // upgrades spawn for 1 player game mode
      UpgradesP2 = [17, 16, 12, 11, 5, 4] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 12
    object
      MapName = "level_13"
      EnemiesPool = 30
      MaxEnemies = 4
      EnemySpawnCooldown = 2.5
      Enemies = [3, 4]
      UpgradesP1 = [23, 15, 10] // upgrades spawn for 1 player game mode
      UpgradesP2 = [23, 22, 15, 14, 10, 9] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 13
    object
      MapName = "level_14"
      EnemiesPool = 30
      MaxEnemies = 4
      EnemySpawnCooldown = 2.5
      Enemies = [3, 4, 5]
      UpgradesP1 = [25, 20, 15] // upgrades spawn for 1 player game mode
      UpgradesP2 = [25, 24, 20, 19, 15, 14] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 14
    object
      MapName = "level_15"
      EnemiesPool = 30
      MaxEnemies = 5
      EnemySpawnCooldown = 2
      Enemies = [3, 4]
      UpgradesP1 = [27, 23, 17] // upgrades spawn for 1 player game mode
      UpgradesP2 = [27, 26, 23, 22, 17, 16] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 15
    object
      MapName = "level_16"
      EnemiesPool = 30
      MaxEnemies = 5
      EnemySpawnCooldown = 2
      Enemies = [4, 5]
      UpgradesP1 = [27, 23, 17] // upgrades spawn for 1 player game mode
      UpgradesP2 = [27, 26, 23, 22, 17, 16] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 16
    object
      MapName = "level_17"
      EnemiesPool = 35
      MaxEnemies = 6
      EnemySpawnCooldown = 2
      Enemies = [4]
      UpgradesP1 = [30, 25, 20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [30, 29, 25, 24, 20, 19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 17
    object
      MapName = "level_18"
      EnemiesPool = 35
      MaxEnemies = 6
      EnemySpawnCooldown = 2
      Enemies = [3]
      UpgradesP1 = [30, 25, 20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [30, 29, 25, 24, 20, 19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 18
    object
      MapName = "level_19"
      EnemiesPool = 35
      MaxEnemies = 6
      EnemySpawnCooldown = 2
      Enemies = [3, 5]
      UpgradesP1 = [30, 25, 20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [30, 29, 25, 24, 20, 19] // upgrades spawn for 2 players game mode
    end,
    // LEVEL 19
    object
      MapName = "level_20"
      EnemiesPool = 50
      MaxEnemies = 8
      EnemySpawnCooldown = 2
      Enemies = [3, 4, 5]
      UpgradesP1 = [40, 30, 20] // upgrades spawn for 1 player game mode
      UpgradesP2 = [40, 39, 30, 29 20, 19] // upgrades spawn for 2 players game mode
    end
  ]

//// PLAYER TANKS /////////////////////////////////////////////////////////////////////////////////////////////////////  
  PlayerTanks = [
    // PLAYER TYPE 0
    object
      HullSpriteP1 = "hull_c_01"
      HullSpriteP2 = "hull_d_01"
      GunSpriteP1 = "gun_c_01"
      GunSpriteP2 = "gun_d_01"
      TrackSprite = "track_01"
      TrackOffset = 6
      MoveSpeed = 0.75
      ProjectileType = 0
      AttackDamage = 100
      ProjectileSpeed = 1
      Cooldown = 1
      MaxHealth = 100
    end,
    // PLAYER TYPE 1 - sniper
    object
      HullSpriteP1 = "hull_c_02"
      HullSpriteP2 = "hull_d_02"
      GunSpriteP1 = "gun_c_02"
      GunSpriteP2 = "gun_d_02"
      TrackSprite = "track_03"
      TrackOffset = 6
      MoveSpeed = 0.75
      ProjectileType = 2
      AttackDamage = 100
      ProjectileSpeed = 4
      Cooldown = 2
      MaxHealth = 100
    end,
    // PLAYER TYPE 2 - speedster
    object
      HullSpriteP1 = "hull_c_08"
      HullSpriteP2 = "hull_d_08"
      GunSpriteP1 = "gun_c_08"
      GunSpriteP2 = "gun_d_08"
      TrackSprite = "track_02"
      TrackOffset = 4
      MoveSpeed = 1.25
      ProjectileType = 0
      AttackDamage = 100
      ProjectileSpeed = 2
      Cooldown = 0.25
      MaxHealth = 100
    end,
    // PLAYER TYPE 2 - titan
    object
      HullSpriteP1 = "hull_c_05"
      HullSpriteP2 = "hull_d_05"
      GunSpriteP1 = "gun_c_07"
      GunSpriteP2 = "gun_d_07"
      TrackSprite = "track_04"
      TrackOffset = 6
      MoveSpeed = 1
      ProjectileType = 3
      AttackDamage = 200
      ProjectileSpeed = 1.5
      Cooldown = 0.75
      MaxHealth = 100
    end
  ]
  
//// ENEMY TANKS //////////////////////////////////////////////////////////////////////////////////////////////////////
  EnemyTanks = [
    // ENEMY TYPE 0 - target hunter lvl 1
    object
      HullSprite = "hull_a_01"
      GunSprite = "gun_a_01"
      TrackSprite = "track_01"
      TrackOffset = 6
      HuntTarget = "TARGET"
      MoveSpeed = 0.25
      MaxObstacklesBeforeFire = 2
      PrefPlayerNumber = 0
      ProjectileType = 0
      AttackDamage = 10
      ProjectileSpeed = 1
      Cooldown = 3
      Health = 100
    end,
    // ENEMY TYPE 1 - player hunter lvl 1
    object
      HullSprite = "hull_a_03"
      GunSprite = "gun_a_03"
      TrackSprite = "track_02"
      TrackOffset = 5
      HuntTarget = "PLAYER"
      MoveSpeed = 0.45
      MaxObstacklesBeforeFire = 2
      PrefPlayerNumber = 0
      ProjectileType = 0
      AttackDamage = 10
      ProjectileSpeed = 1
      Cooldown = 2
      Health = 100
    end,
    // ENEMY TYPE 2 - target hunter artilery lvl 1
    object
      HullSprite = "hull_a_02"
      GunSprite = "gun_a_02"
      TrackSprite = "track_03"
      TrackOffset = 6
      HuntTarget = "TARGET"
      MoveSpeed = 0.20
      MaxObstacklesBeforeFire = 6
      PrefPlayerNumber = 0
      ProjectileType = 1
      AttackDamage = 25
      ProjectileSpeed = 1
      Cooldown = 5
      Health = 100
    end,
    // ENEMY TYPE 3 - target hunter lvl 2
    object
      HullSprite = "hull_a_06"
      GunSprite = "gun_a_06"
      TrackSprite = "track_01"
      TrackOffset = 6
      HuntTarget = "TARGET"
      MoveSpeed = 0.5
      MaxObstacklesBeforeFire = 2
      PrefPlayerNumber = 0
      ProjectileType = 0
      AttackDamage = 20
      ProjectileSpeed = 1.2
      Cooldown = 3
      Health = 200
    end,
    // ENEMY TYPE 4 - player hunter lvl 2
    object
      HullSprite = "hull_a_08"
      GunSprite = "gun_a_08"
      TrackSprite = "track_03"
      TrackOffset = 5
      HuntTarget = "PLAYER"
      MoveSpeed = 0.65
      MaxObstacklesBeforeFire = 2
      PrefPlayerNumber = 0
      ProjectileType = 2
      AttackDamage = 20
      ProjectileSpeed = 1.2
      Cooldown = 2
      Health = 200
    end,
    // ENEMY TYPE 5 - target hunter artilery lvl 2
    object
      HullSprite = "hull_a_07"
      GunSprite = "gun_a_07"
      TrackSprite = "track_07"
      TrackOffset = 6
      HuntTarget = "TARGET"
      MoveSpeed = 0.20
      MaxObstacklesBeforeFire = 10
      PrefPlayerNumber = 0
      ProjectileType = 1
      AttackDamage = 50
      ProjectileSpeed = 1.5
      Cooldown = 5
      Health = 300
    end
  ]
  
//// PROJECTILES //////////////////////////////////////////////////////////////////////////////////////////////////////
  ProjectileTypes = [
    // PROJECTILE TYPE 0
    object
      Sprite = "light_shell"
      Sound = "rlauncher"
      SpriteSizeX = 10
      SpriteSizeY = 10
      CollisionSizeX = 4
      CollisionSizeY = 4
    end,
    // PROJECTILE TYPE 1 - artilery
    object
      Sprite = "heavy_shell"
      Sound = "ren"
      SpriteSizeX = 12
      SpriteSizeY = 12
      CollisionSizeX = 5
      CollisionSizeY = 5
    end,
    // PROJECTILE TYPE 2 - high speed/sniper
    object
      Sprite = "plasma"
      Sound = "ren3"
      SpriteSizeX = 12
      SpriteSizeY = 12
      CollisionSizeX = 5
      CollisionSizeY = 5
    end,
    // PROJECTILE TYPE 3 - big one
    object
      Sprite = "grenade"
      Sound = "teleport"
      SpriteSizeX = 15
      SpriteSizeY = 15
      CollisionSizeX = 10
      CollisionSizeY = 10
    end
  ]
end