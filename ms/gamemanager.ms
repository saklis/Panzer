// game object - holds game logic

GameManager = class
  
//// constructor
  constructor = function()
    // all entities in the game world
    Gameworld = 0
    
    // physcs engine instance
    Physics = 0
    
    // map engine instance
    Map = 0
    
    // AI overseer instance
    Ai = 0
    
    // UI Manager instance
    Ui = 0
    
    // Database Index of current level
    CurrentLevelIndex = 0
    
    // ref to player entities
    Player1 = 0
    Player2 = 0
    
    // entity that is an enemy target. If destroyed then game is lost
    Target = 0
    
    // cumulative score for all players
    Score = 0
    Player1Kills = 0
    Player2Kills = 0
    
    // number of draw layers
    DrawLayersCount = 3
    
    // timer used in GameOver_PlayerWon() and GameOver_PlayerLost() to give player play for extra seconds after condition was met
    // prevents sudden cut to  win/lost intermission screen
    GameFinishedTimer = 0
    // on game over, holds information if player won the game
    PlayerWon = 0
  end
  
//// AddSpecialEntities - add special entities based on possition data from loaded map
  AddSpecialEntities = function()
    // PLAYER 1 entity
    if Map.Player1StartPosition != 0 then
      local playerTank = Database.PlayerTanks[0]
      Player1 = new Entity("player1")
      Player1.AddComponent(new TransformComponent(Map.Player1StartPosition.X, Map.Player1StartPosition.Y))
      Player1.AddComponent(new TankSpriteComponent(playerTank.HullSpriteP1, playerTank.GunSpriteP1, playerTank.TrackSprite, playerTank.TrackOffset))
      Player1.AddComponent(new PlayerControllerComponent(1, playerTank.MoveSpeed))
      Player1.AddComponent(new CollisionComponent("PLAYER", Map.Player1StartPosition.X, Map.Player1StartPosition.Y, 15, 15, true, true))
      //Player1.AddComponent(new AiControllerComponent("ENEMYFIRST", playerTank.MoveSpeed, 3))
      //Player1.AddComponent(new CollisionComponent("PLAYER", Map.Player1StartPosition.X, Map.Player1StartPosition.Y, 15, 15, true, false))
      Player1.AddComponent(new HealthComponent(playerTank.MaxHealth))
      Player1.AddComponent(new AttackComponent(playerTank.ProjectileType, playerTank.AttackDamage, playerTank.ProjectileSpeed, playerTank.Cooldown))
      Player1.AddComponent(new UpgradeComponent(0))
      Spawn(Player1)
    end
    // PLAYER 2 entity
    if Input.Player2 != 0 and Map.Player2StartPosition != 0 then
      local playerTank = Database.PlayerTanks[0]
      Player2 = new Entity("player2")
      Player2.AddComponent(new TransformComponent(Map.Player2StartPosition.X, Map.Player2StartPosition.Y))
      Player2.AddComponent(new TankSpriteComponent(playerTank.HullSpriteP2, playerTank.GunSpriteP2, playerTank.TrackSprite, playerTank.TrackOffset))
      Player2.AddComponent(new PlayerControllerComponent(2, playerTank.MoveSpeed))
      Player2.AddComponent(new CollisionComponent("PLAYER", Map.Player1StartPosition.X, Map.Player1StartPosition.Y, 15, 15, true, true))
      //Player2.AddComponent(new AiControllerComponent("ENEMYLAST", playerTank.MoveSpeed, 3))
      //Player2.AddComponent(new CollisionComponent("PLAYER", Map.Player1StartPosition.X, Map.Player1StartPosition.Y, 15, 15, true, false))
      Player2.AddComponent(new HealthComponent(playerTank.MaxHealth))
      Player2.AddComponent(new AttackComponent(playerTank.ProjectileType, playerTank.AttackDamage, playerTank.ProjectileSpeed, playerTank.Cooldown))
      Player2.AddComponent(new UpgradeComponent(0))
      Spawn(Player2)
    end
    // TARGET entity
    if Map.TargetPosition != 0 then
      Target = new Entity("target")
      Target.AddComponent(new TransformComponent(Map.TargetPosition.X, Map.TargetPosition.Y))
      Target.AddComponent(new SpriteComponent("goalstar", 2, 16, 16))
      Target.AddComponent(new CollisionComponent("WALL", Map.TargetPosition.X, Map.TargetPosition.Y, 16, 16, false, false))
      Target.AddComponent(new HealthComponent(1))
      Spawn(Target)
    end
  end
  
//// Spawn - add entity to the game world and call init() for it
  // @entity:Entity - object to add to game world. Instance of class that extends Entity
  Spawn = function(entity)
    Gameworld.push(entity)
    entity.Game = this
    entity.Init()
  end
  
//// Spawns effect - dedicated entity with just transform and sprite components
  // @spriteName:string - name of the effect sprite
  // @posX:number - position of the effect on x axis
  // @posY:number - position of the effect on y axis
  // @sizeX:number - size of effect on x axis
  // @sizeY:number - size of effect on y axis
  // @rotation:number - rotation in angles
  // @lifetime:number - how long the effect should stay in game world
  SpawnEffect = function(spriteName, posX, posY, sizeX, sizeY, rot, lifetime)
    local explosion = new Entity("effect")
    explosion.AddComponent(new TransformComponent(posX, posY, rot))
    explosion.AddComponent(new SpriteComponent(spriteName, 3, sizeX, sizeY, lifetime))
    Spawn(explosion)
  end
  
//// Destroy - Remove entity from game world. Entity will be marked as deleted and removed on next global update
  // @entity:Entity - object to remove from game world. Instance of class that extends Entity
  // @instigator:Entity - entity that fired projectile that destroyed object
  Destroy = function(entity, instigator)
    // if any player destroyed - game over
    if entity == Player1 or entity == Player2 then
      // spawn explosion effect
      local position = entity.Transform.Position
      local rotation = random.nextInt(8) * 45
      SpawnEffect("enemy_explo", position.X, position.Y, 128, 128, rotation, 2.1)
      
      // player is dead - game over
      GameOver_PlayerLost()
    end
    
    if entity == Target then
      // spawn explosion effect
      local position = entity.Transform.Position
      SpawnEffect("targetexplosion", position.X, position.Y, 128, 128, 0, 2.1)
      
      // target destroyed - game over
      GameOver_PlayerLost()
    end
    
    // if enemy was destroyed - inform AI Overseer
    if entity.Name.startsWith("enemy") then
      Score += 100
      if instigator == Player1 then Player1Kills += 1 end
      if instigator == Player2 then Player2Kills += 1 end
      Ai.EnemyDestroyed(entity)
      
      // spawn explosion effect
      local position = entity.Transform.Position
      local rotation = random.nextInt(8) * 45
      SpawnEffect("enemy_explo", position.X, position.Y, 80, 80, rotation, 2.1)
      // sound effect
      Noise.EnemyDied()
      
      // check if enemies left mets upgrade threshold
      local thresholds = Database.GetUpgrades()
      local enemiesLeft = Ai.Enemies.length + Ai.EnemiesPool
      // if yes, spawn upgrade trigger entity in place of destroyed enemy
      if thresholds.contains(enemiesLeft) then
        local position = entity.Transform.Position
        
        local upgrade = new Entity("upgrade")
        upgrade.AddComponent(new TransformComponent(position.X, position.Y))
        upgrade.AddComponent(new SpriteComponent("upgrade", 1, 16, 16))
        upgrade.AddComponent(new CollisionComponent("TRIGGER", position.X, position.Y, 5, 5, false, true))
        Game.Spawn(upgrade)
      end
    end
    
    // if part of map was destroyed - inform map engin
    if entity.Name.startsWith("map") then
      Map.MapDestroyed(entity)
      Ai.BuildVectorFieldToTarget()
      
      // spawn explosion effect
      local position = entity.Transform.Position
      local rotation = random.nextInt(8) * 45
      SpawnEffect("map_explo", position.X, position.Y, 64, 64, rotation, 1.1)
      // sound effect
      Noise.MapDestroyed()
    end
    
    // mark entity for deletion
    entity.Delete = true
  end
  
//// GameOver_PlayerWon - called when player won
  GameOver_PlayerWon = function()
    PlayerWon = true
    GameFinishedTimer = 0.000001 // start timer to the end of game
    Noise.StopMusic()
    Noise.WinJingle()
  end
  
//// GameOver_PlayerLost - called when player lost
  GameOver_PlayerLost = function()
    PlayerWon = false
    GameFinishedTimer = 0.000001 // start timer to the end of game
    Noise.StopMusic()
    Noise.LoseJingle()
  end
  
//// FindEntityByName - returns first entity with name that starts with the supplied string.
  // @name:string - string that will be matched against beginning of entity's name
  // @return:Entity - Entity with name matching the string. Returns 0 if no entity was found
  FindEntityByName = function(name)
    for entity in Gameworld
      if entity.Name.startsWith(name) then return entity end
    end
    return 0
  end

//// FindAllEntitiesByName - returns list with all entities with name that starts with the supplied string
  // @name:string - string that will be matched against beginning of entity's name
  // @returns:Entity[] - list of all entities with names matching the string. Returns empty list if no entity was found
  FindAllEntitiesByName = function(name)
    local entities = []
    
    for entity in Gameworld
      if entity.Name.startsWith(name) then entities.push(entity) end
    end
    
    return entities
  end
  
//// Init - init game world - call init() for all entities that are already in the game world
  Init = function()
    // score for this round
    Score = 0
    Player1Kills = 0
    Player2Kills = 0
    
    // initialize game world
    Gameworld = []
    
    // initialize physics engine
    Physics = new PhysicEngine()
    Physics.Init()
    
    // initialize AI overseer
    Ai = new AiOverseer(this)
    
    // initialize map engine
    Map = new MapEngine()
    
    // load level
    Map.LoadMap(Database.GetMapName())
    for entity in Map.Entities
      Spawn(entity)
    end

    // add special entities - player, target point, etc.
    AddSpecialEntities()
    
    // build ai nav map
    Ai.BuildVectorFieldToTarget()
    
    Ai.EnemySpawnPoints = Map.EnemyStartPositions
    // enemies are spawned in AiOverseer in Update() function
    
    Ui = new UiManager()
  end
  
//// Update - update all entities in game world
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    Score -= deltaTime // lower score by 1 per second
    
    // if game ended, increase GameFinishedTimer timer
    if GameFinishedTimer > 0 then 
      GameFinishedTimer += deltaTime
    end
    if GameFinishedTimer > 4 then
      GameFinishedTimer = 0
      GameFinished(PlayerWon) // game finished. Defined in main.ms
    end
    
    local deletedEntities = []
    
    // update physics state
    Physics.Update(deltaTime)
    
    // update AI state
    Ai.Update(deltaTime)
    
    // update game state
    for entity in Gameworld
      if entity.Delete == false then
        entity.Update(deltaTime)
      else
        deletedEntities.push(entity)
      end
    end
    
    // delete marked entities
    for entity in deletedEntities
      local index = Gameworld.indexOf(entity)
      entity.Destroy()
      Gameworld.removeAt(index)
    end
  end
  
//// Draw - draw all entities in game world
  Draw = function()
    for layer = 0 to DrawLayersCount
      for entity in Gameworld
        entity.Draw(layer)
      end
    end
    
    //draw ui
    Ui.Draw()
    
    // DEBUG draw calls
    //Physics.DEBUG_DrawColliders()
    //Ai.DEBUG_DrawTargetVectorField()
    //Ai.DEBUG_DrawPlayer1VectorField()
    //Map.DEBUG_DisplayNavGrid()
  end
end