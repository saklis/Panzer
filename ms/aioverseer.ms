// represents AI overseer that coordinates AI components

AiOverseer = class
  
//// constructor
  constructor = function()
    
    // 2D list of vectors. Holds next move from current position on the way to target
    TargetVectorField = 0
    // 2D list of vectors. Holds next move from current position on the way to Player 1
    Player1VectorField = 0
    // 2D list of vectors. Holds next move from current position on the way to Player 2
    Player2VectorField = 0
    // list of EnemyVectorFieldTuple used in demo mode
    EnemiesVectorFields = []
    
    // Number of enemies left. When reach 0 AI Overseer is not allowed to spawn more
    EnemiesPool = Database.GetEnemiesPool()
    
    // Max number of enemies alive at the same time
    MaxEnemies = Database.GetMaxEnemies()
    
    // List of enemies currently on the map 
    Enemies = []
    
    // list of Vector2D of enemy spawn points
    EnemySpawnPoints = []
    
    // cooldown in seconds between spawns of enemies
    EnemySpawnCooldown = Database.GetEnemySpawnCooldown()
    EnemySpawnCooldownTimer = 0 // timer incereased in Update(). When equals 0, then next enemy can be spawn
    
    // flag that tells if Update() for AI Overseer is performed. Used to diable Update when in game over state
    IsUpdateDisabled = false
  end
  
//// SpawnNextEnemy - spawns next enemy 
  SpawnNextEnemy = function()
    if EnemySpawnPoints.length > 0 then
      // get enemy data from Database
      local enemyData = Database.GetEnemy()
      
      local enemy = new Entity("enemy")
      local spawnPointIndex = random.nextInt(EnemySpawnPoints.length)
      enemy.AddComponent(new TransformComponent(EnemySpawnPoints[spawnPointIndex].X, EnemySpawnPoints[spawnPointIndex].Y))
      enemy.AddComponent(new TankSpriteComponent(enemyData.HullSprite, enemyData.GunSprite, enemyData.TrackSprite, enemyData.TrackOffset))
      enemy.AddComponent(new AiControllerComponent(enemyData.HuntTarget, enemyData.MoveSpeed, enemyData.MaxObstacklesBeforeFire, enemyData.PrefPlayerNumber))
      enemy.AddComponent(new AttackComponent(enemyData.ProjectileType, enemyData.AttackDamage, enemyData.ProjectileSpeed, enemyData.Cooldown))
      enemy.AddComponent(new HealthComponent(enemyData.Health))
      enemy.AddComponent(new CollisionComponent("ENEMY", EnemySpawnPoints[spawnPointIndex].X, EnemySpawnPoints[spawnPointIndex].Y, 16, 16, true, false))
      Game.Spawn(enemy)
      
      // enemy spawn VFX and SFX
      Game.SpawnEffect("poof", EnemySpawnPoints[spawnPointIndex].X, EnemySpawnPoints[spawnPointIndex].Y, 60, 60, 0, 1.16)
      Noise.EnemySpawned()
      
      Enemies.push(enemy) // add enemy to list of alive enemies
      EnemiesPool -= 1 // decrease number of enemies that are still waiting to be spawned
    end
  end
  
//// EnemyDestroyed - called by GameManager, informs Ai Overseer that one of the enemies was destroyed
  // @enemyEntity:Entity - enemy that was destroyed
  EnemyDestroyed = function(enemyEntity)
    // remove enemy from the list of alive enemies
    Enemies.removeElement(enemyEntity)
  end
  
//// GetNextStepToTarget - Get NavGrid cell coords for next step on the path to target
  // @currentX:int - X element of coords of current location
  // @currentY:int - Y element of coords of current location
  // @returns:Vector2D - vector with coords of next step on path to target. Returns 0 if no path available or already on target
  GetNextStepToTarget = function(currentX, currentY)
    local next = TargetVectorField[currentX][currentY]
    if next == 0 or next == 1 then return 0
    else return next end
  end
  
//// GetNextStepToPlayer1 - Get NavGrid cell coords for next step on the path to Player 1
  // @currentX:int - X element of coords of current location
  // @currentY:int - Y element of coords of current location
  // @returns:Vector2D - vector with coords of next step on path to Player 1. Returns 0 if no path available or already on Player 1 position  
  GetNextStepToPlayer1 = function(currentX, currentY)
    if Player1VectorField == 0 then return 0 end
      
    local next = Player1VectorField[currentX][currentY]
    if next == 0 or next == 1 then return 0
    else return next end
  end
  
//// GetNextStepToPlayer2 - Get NavGrid cell coords for next step on the path to Player 2
  // @currentX:int - X element of coords of current location
  // @currentY:int - Y element of coords of current location
  // @returns:Vector2D - vector with coords of next step on path to Player 1. Returns 0 if no path available or already on Player 1 position  
  GetNextStepToPlayer2 = function(currentX, currentY)
    if Player2VectorField == 0 then return 0 end
      
    local next = Player2VectorField[currentX][currentY]
    if next == 0 or next == 1 then return 0
    else return next end
  end
  
//// GetNextStepToEnemy - Get NavGrid cell coords for next step on the path to supplied enemy
  //                      This is only used in demo mode and additionally can rebuild VectorField if it's needed.
  // @enemy:Entity - reference to enemy
  // @currentX:int - X element of coords of current location
  // @currentY:int - Y element of coords of current location
  // @returns:Vector2D - vector with coords of next step on path to enemy. Returns 0 if already on enemy position  
  GetNextStepToEnemy = function(enemy, currentX, currentY)
    local field = 0
    for tuple in EnemiesVectorFields
      if tuple.EnemyId == enemy.Id then field = tuple.VectorField end
    end
    if field == 0 then
      local enemyPos = enemy.Transform.Position
      field = BuildVectorField(enemyPos)
      EnemiesVectorFields.push(new EnemyVectorFieldTuple(enemy.Id, field))
    end
      
    local next = field[currentX][currentY]
    if next == 0 or next == 1 then 
      // if 0 or 1 then target moved and new VectorField needs to be generated
      for tuple in EnemiesVectorFields
        if tuple.EnemyId == enemy.Id then 
          local enemyPos = enemy.Transform.Position
          tuple.VectorField = BuildVectorField(enemyPos)
          return tuple.VectorField[currentX][currentY]
        end
      end
    else return next end
  end
  
//// BuildVectorFieldToTarget - Generates Vector Field to Target Entity using Breadth First Search.
  BuildVectorFieldToTarget = function()
    if Game.Target != 0 then
      local targetPosition = Game.Target.Transform.Position
      TargetVectorField = BuildVectorField(targetPosition, false)
    end
  end

//// BuildVectorFieldToPlayer1 - Generates Vector Field to Player 1 Entity using Breadth First Search.  
  BuildVectorFieldToPlayer1 = function()
    if Game.Player1 != 0 then
      local player1Position = Game.Player1.Transform.Position
      Player1VectorField = BuildVectorField(player1Position, true)
    end
  end
  
//// BuildVectorFieldToPlayer2 - Generates Vector Field to Player 2 Entity using Breadth First Search.  
  BuildVectorFieldToPlayer2 = function()
    if Game.Player2 != 0 then
      local player2Position = Game.Player2.Transform.Position
      Player2VectorField = BuildVectorField(player2Position, true)
    end
  end
  
//// BuildVectorField - generates Vector Field to supplied position using Breadth First Search
  //                    Based on https://www.redblobgames.com/pathfinding/tower-defense/
  // @targetPosition:Vector2D - position that is target of pathfinding
  // @includeBunker:bool - if set to 'true' then constructed vector field will include bunker entities as impassable
  // @returns:Vector2D[][] - 2D list of Vector2D objects, that holds next step on path to target
  BuildVectorField = function(targetPosition, includeBunker)
    local blockWidth = Game.Map.CurrentMap.block_width
    local blockHeight = Game.Map.CurrentMap.block_height
    
    // target coords in GridNav system
    local targetNavX = floor((targetPosition.X + 160) / blockWidth)
    local targetNavY = floor((targetPosition.Y + 84) / blockHeight)
    
    // init vectorField - fill with 0
    local vectorField = []
    for x = 0 to Game.Map.CurrentMap.width - 1
      vectorField.push([])
      for y = 0 to Game.Map.CurrentMap.height - 1
        vectorField[x].push(0)
      end
    end
    
    // set 1 in the location of target
    vectorField[targetNavX][targetNavY] = 1
    
    // get frontier - all nodes that borders current one
    local frontier = GetFrontier(targetNavX, targetNavY, vectorField, includeBunker) // on first iteration find frontier for target
    while frontier.length > 0 // until frontier is empty
      // add all nodes from frontier to TargetVectorField
      for node in frontier
        vectorField[node.PositionX][node.PositionY] = new Vector2D(node.ComeFromX, node.ComeFromY)
      end
      
      // select next node to act as center to find frontier for
      local nextNode = frontier[0]
      frontier.removeAt(0)
      
      // include frontier for this new node into existing frontier
      frontier = frontier.concat(GetFrontier(nextNode.PositionX, nextNode.PositionY, vectorField, includeBunker))
    end // while
    
    return vectorField
  end

//// GetFrontier - Search map's NavGrid. Get all traversable nodes neighbouring provided coords
  // @x:int - X element of provided coords
  // @y:int - Y element of provided coords
  // @vectorField:Vector2D[][] - current state of vector field being build
  // @includeBunker:bool - if set to 'true' it will check if cell contains bunker entity and mark those as immpassable
  // @returns:VectorFieldNode[] - list of VectorFieldNode objects
  GetFrontier = function(x, y, vectorField, includeBunker)
    local frontier = []
    
    // Search NavGrid. Add nodes that hold 0 (traversable) and are not yet in TargetVectorField
    local navGrid = Game.Map.NavGrid
    
    // check all nodes that are neighbouring center element on X and Y axis (not diagonally)
    // if the cell exists (is within NavGrid bounds) and was not checked before (value in vectorField is still 0)
    // then add thios cell to frontier with info about it's center. Checks bunker if requested by function's argument.
    
    if x-1 >= 0 then
      if navGrid[x-1][y] == 0 and vectorField[x-1][y] == 0 then 
        local isTraversable = true
        if includeBunker == true then
          for pos in Game.Map.BunkerPositions
            if pos.X == x-1 and pos.Y == y then 
              isTraversable = false 
            end
          end
        end
        if isTraversable == true then
          frontier.push(new VectorFieldNode(x-1, y, x, y))
        end
      end
    end
    
    if x+1 < Game.Map.CurrentMap.width then
      if navGrid[x+1][y] == 0 and vectorField[x+1][y] == 0 then 
        local isTraversable = true
        if includeBunker == true then
          for pos in Game.Map.BunkerPositions
            if pos.X == x+1 and pos.Y == y then 
              isTraversable = false 
            end
          end
        end
        if isTraversable == true then
          frontier.push(new VectorFieldNode(x+1, y, x, y)) 
        end
      end
    end
    
    if y-1 >= 0 then
      if navGrid[x][y-1] == 0 and vectorField[x][y-1] == 0 then 
        local isTraversable = true
        if includeBunker == true then
          for pos in Game.Map.BunkerPositions
            if pos.X == x and pos.Y == y-1 then 
              isTraversable = false 
            end
          end
        end
        if isTraversable == true then
          frontier.push(new VectorFieldNode(x, y-1, x, y)) 
        end
      end
    end
    
    if y+1 < Game.Map.CurrentMap.height then
      if navGrid[x][y+1] == 0 and vectorField[x][y+1] == 0 then
        local isTraversable = true
        if includeBunker == true then
          for pos in Game.Map.BunkerPositions
            if pos.X == x and pos.Y == y+1 then 
              isTraversable = false 
            end
          end
        end
        if isTraversable == true then
          frontier.push(new VectorFieldNode(x, y+1, x, y)) 
        end
      end
    end
  
    return frontier
  end
  
//// Update - called every frame to allow AI Overseer to monitor the situation on the map
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    if IsUpdateDisabled == false then
      // check how many enemies are on the map and spawn new one if you can
      if EnemiesPool <= 0 and Enemies.length == 0 then
        // no more enemies - player won - game over
        IsUpdateDisabled = true
        Game.GameOver_PlayerWon()
      end
      
      // update enemy spawn cooldown
      if EnemySpawnCooldownTimer > 0 then EnemySpawnCooldownTimer += deltaTime end
      if EnemySpawnCooldownTimer >= EnemySpawnCooldown then EnemySpawnCooldownTimer = 0 end
      
      // spawn next enemy if allowed
      if Enemies.length < MaxEnemies and EnemiesPool > 0 and EnemySpawnCooldownTimer == 0 then
        SpawnNextEnemy()
        EnemySpawnCooldownTimer = 0.00001
      end
    end
  end
  
//// DEBUG_DrawTargetVectorField - draws text on each node with coords of next step on path to target
  DEBUG_DrawTargetVectorField = function()
    for x = 0 to Game.Map.CurrentMap.width - 1
      for y = 0 to Game.Map.CurrentMap.height - 1
        local node = TargetVectorField[x][y]
        if node == 0 or node == 1 then
          screen.drawText(node, x * 16 - 160 + 8, y * 16 - 84 + 8, 8, "rgb(255,255,255)")
        else
          screen.drawText(x + "x" + y, x * 16 - 160 + 8, y * 16 - 84 + 10, 4, "rgb(255,255,255)")
          local text = "(" + node.X + "," + node.Y + ")"
          screen.drawText(text, x * 16 - 160 + 8, y * 16 - 84 + 6, 4, "rgb(255,255,255)")
        end
      end
    end
  end
  
//// DEBUG_DrawPlayer1VectorField - draws text on each node with coords of next step on path to PLayer 1
  DEBUG_DrawPlayer1VectorField = function()
    if Player1VectorField != 0 then
      for x = 0 to Game.Map.CurrentMap.width - 1
        for y = 0 to Game.Map.CurrentMap.height - 1
          local node = Player1VectorField[x][y]
          if node == 0 or node == 1 then
            screen.drawText(node, x * 16 - 160 + 8, y * 16 - 84 + 8, 8, "rgb(255,255,255)")
          else
            screen.drawText(x + "x" + y, x * 16 - 160 + 8, y * 16 - 84 + 10, 4, "rgb(255,255,255)")
            local text = "(" + node.X + "," + node.Y + ")"
            screen.drawText(text, x * 16 - 160 + 8, y * 16 - 84 + 6, 4, "rgb(255,255,255)")
          end
        end
      end
    end
  end
end