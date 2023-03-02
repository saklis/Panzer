// handles loading maps

MapEngine = class
//// constructor
  constructor = function()
    // list of entities created based on current map
    Entities = []
    
    // 2D list with 1's and 0's. Used for navigation: 0 - traversable; 1 - not-traversable
    NavGrid = 0
    
    // reference to currently loaded Map object
    CurrentMap = 0
    
    // Vector2D with position of Target
    TargetPosition = 0
    
    // Vector2Ds with position of Player start points
    Player1StartPosition = 0
    Player2StartPosition = 0
    
    // list of Vecotr2D with positions of starting points for enemies
    EnemyStartPositions = []
    
    // list of Vecotr2D with position (in NavGrid units) bunker entities.
    // this is separate from normal NavGrid, because those should block only some of the AI entities
    BunkerPositions = []
  end
  
//// LoadMap - loads map and creates all Entities. Fills NavGrids.
  // @mapName:string - name of the map asset
  LoadMap = function(mapName)
    // add ground
    AddGround()
    
    // add map
    AddMap(mapName)
    
    // add walls
    AddWalls()
  end
  
//// MapDestroyed - called by GameManager when part of the map is destroyed
  // @destroyedEntity:Entity - Entity that was destroyed
  MapDestroyed = function(destroyedEntity)
    // update NavGrid
    local position = destroyedEntity.Transform.Position
    local navGridX = (position.X - (CurrentMap.block_width / 2) + 160) / CurrentMap.block_width
    local navGridY = (position.Y - (CurrentMap.block_height / 2) + 84) / CurrentMap.block_height
    
    NavGrid[navGridX][navGridY] = 0
  end
  
//// AddGround - adds Entity coresponds to ground under everything
  AddGround = function()
    local ground = new Entity("ground")
    ground.AddComponent(new TransformComponent(0, 4))
    ground.AddComponent(new RectComponent(0, 320, 176, "rgb(20,75,19)"))
    Entities.push(ground)
    
    for i = 0 to 20
      local posX = random.nextInt(304) - 152
      local posY = random.nextInt(152) - 76
      local foliage = random.nextInt(2)
      local scaleX = 0.5
      local scaleY = 0.5
      if foliage == 0 then scaleY = 0.25 end
      
      local sign = -1
      if random.nextInt(2) == 1 then sign = 1 end
      
      local deco = new Entity("ground_deco")
      deco.AddComponent(new TransformComponent(posX, posY, 0, sign * scaleX, scaleY))
      if foliage == 0 then deco.AddComponent(new AssetSpriteComponent(1, 208, 0, 16, 16)) end
      if foliage == 1 then deco.AddComponent(new AssetSpriteComponent(1, 224, 0, 16, 16)) end
      Entities.push(deco)
    end
  end
  
//// AddWalls - adds Entities that coresponds to walls around the arena
  AddWalls = function()
    local wall = 0
    
    // add horizontal walls at the top (y = 96) and bottom (y = -88)
    for x = -164 to 164 by 8
      wall = new Entity("wall")
      wall.AddComponent(new TransformComponent(x, -88, 0, 0.25, 0.25))
      wall.AddComponent(new SpriteComponent("wall", 2, 8, 8))
      wall.AddComponent(new CollisionComponent("WALL", x, -88, 8, 8))
      Entities.push(wall)
      
      wall = new Entity("wall")
      wall.AddComponent(new TransformComponent(x, 96, 0, 0.25, 0.25))
      wall.AddComponent(new SpriteComponent("wall", 2, 8, 8))
      wall.AddComponent(new CollisionComponent("WALL", x, 96, 8, 8))
      Entities.push(wall)
    end
    
    // add vertical walls on the left (x = -164) and right (x = 164)
    for y = -80 to 88 by 8
      wall = new Entity("wall")
      wall.AddComponent(new TransformComponent(-164, y, 0, 0.25, 0.25))
      wall.AddComponent(new SpriteComponent("wall", 2, 8, 8))
      wall.AddComponent(new CollisionComponent("WALL", -164, y, 8, 8))
      Entities.push(wall)
      
      wall = new Entity("wall")
      wall.AddComponent(new TransformComponent(164, y, 0, 0.25, 0.25))
      wall.AddComponent(new SpriteComponent("wall", 2, 8, 8))
      wall.AddComponent(new CollisionComponent("WALL", 164, y, 8, 8))
      Entities.push(wall)
    end
  end
  
//// AddMap - add entities based on map asset
  // @mapName:string - name of map asset
  AddMap = function(mapName)
    local entity = 0
    
    local mapCell = ""
    
    local spriteName = ""
    local spriteCellX = 0
    local spriteCellY = 0
    local entityPosX = 0
    local entityPosY = 0
    
    CurrentMap = maps[mapName]
    
    // init NavGrid and fill with 0s
    NavGrid = []
    for x = 0 to CurrentMap.width - 1
      NavGrid.push([])
      for y = 0 to CurrentMap.height - 1
        NavGrid[x].push(0)
      end
    end
    
    // read map asset and create Entities depending on sprites in each node
    for x = 0 to CurrentMap.width - 1
      for y = 0 to CurrentMap.height - 1
        mapCell = CurrentMap.get(x, y)
        if mapCell != 0 then
          entityPosX = floor((x * CurrentMap.block_width) + (CurrentMap.block_width / 2) - 160)
          entityPosY = floor((y * CurrentMap.block_height) + (CurrentMap.block_height / 2) - 84)
            
          if mapCell == "player1start" then
            Player1StartPosition = new Vector2D(entityPosX, entityPosY)
          elsif mapCell == "player2start" then
            Player2StartPosition = new Vector2D(entityPosX, entityPosY)
          elsif mapCell == "targetpoint" then
            TargetPosition = new Vector2D(entityPosX, entityPosY)
            AddBunkerAround(entityPosX, entityPosY) // add destructibe bunker around target location
          elsif mapCell == "enemystart" then
            EnemyStartPositions.push(new Vector2D(entityPosX, entityPosY))
          elsif mapCell == "ocean" then
            entity = new Entity("map_ocean")
            entity.AddComponent(new TransformComponent(entityPosX, entityPosY))
            entity.AddComponent(new CollisionComponent("WATER", entityPosX, entityPosY, 16, 16, false, false))
            entity.AddComponent(new SpriteComponent("ocean", 1, 16, 16, 0))
            Entities.push(entity)
            // occupied space
            NavGrid[x][y] = 1
          elsif mapCell == "vines" then
            entity = new Entity("map_vines")
            entity.AddComponent(new TransformComponent(entityPosX, entityPosY))
            entity.AddComponent(new SpriteComponent("vines", 3, 16, 16, 0))
            Entities.push(entity)
            // passable decoration
            NavGrid[x][y] = 0
          else
            spriteName = mapCell.split(":")[0]
            spriteCellX = mapCell.split(":")[1].split(",")[0]
            spriteCellY = mapCell.split(":")[1].split(",")[1]
            
            entity = new Entity("map")
            entity.AddComponent(new TransformComponent(entityPosX, entityPosY))
            entity.AddComponent(new CollisionComponent("WALL", entityPosX, entityPosY, 16, 16, false, false))
            entity.AddComponent(new HealthComponent(100))
            entity.AddComponent(
              new AssetSpriteComponent(
                1, 
                spriteCellX * CurrentMap.block_width, 
                spriteCellY * CurrentMap.block_height, 
                CurrentMap.block_width, 
                CurrentMap.block_height, 
                CurrentMap.block_width, 
                CurrentMap.block_height
              )
            )
            Entities.push(entity)
            // occupied space
            NavGrid[x][y] = 1
          end
        else
          // empty space - navigable terrain
          NavGrid[x][y] = 0
        end
      end
    end
  end
  
//// AddBunkerAround - adds 8 destructible entities to form bunker around location.
  AddBunkerAround = function(targetX, targetY)
    if targetX - 16 >= -152 and targetY - 16 >= -76 then
      AddBunkerAt(targetX - 16, targetY - 16)
    end
    if targetY - 16 >= -76 then
      AddBunkerAt(targetX, targetY - 16)
    end
    if targetX + 16 <= 152 and targetY - 16 >= -76 then
      AddBunkerAt(targetX + 16, targetY - 16)
    end
    
    if targetX - 16 >= -152 then
      AddBunkerAt(targetX - 16, targetY)
    end
    if targetX + 16 <= 152 then
      AddBunkerAt(targetX + 16, targetY)
    end
    
    if targetX - 16 >= -152 and targetY + 16 <= 76 then
      AddBunkerAt(targetX - 16, targetY + 16)
    end
    if targetY + 16 <= 76 then
      AddBunkerAt(targetX, targetY + 16)
    end
    if targetX + 16 <= 152 and targetY + 16 <= 76 then
      AddBunkerAt(targetX + 16, targetY + 16)
    end
  end
  
  AddBunkerAt = function(posX, posY)
    local entity = new Entity("map_bunker")
    entity.AddComponent(new TransformComponent(posX, posY))
    entity.AddComponent(new CollisionComponent("WALL", posX, posY, 16, 16, false, false))
    entity.AddComponent(new HealthComponent(200))
    entity.AddComponent(new SpriteComponent("bunker", 1, 16, 16, 0))
    Entities.push(entity)
    
    local bunkerNavPos = new Vector2D(
      (posX - (CurrentMap.block_width / 2) + 160) / CurrentMap.block_width,
      (posY - (CurrentMap.block_height / 2) + 84) / CurrentMap.block_height
    )
    BunkerPositions.push(bunkerNavPos)
  end
  
//// DEBUG_DisplayNavGrid - display NavGrid value on each node
  DEBUG_DisplayNavGrid = function()
    for x = 0 to CurrentMap.width - 1
      for y = 0 to CurrentMap.height -1
        local value = NavGrid[x][y]
        screen.drawText(value, x * 16 - 160 + 8, y * 16 - 84 + 8, 8, "rgb(255,255,255)")
      end
    end
  end

end