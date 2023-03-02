// AI Component that controls specific Entity

AiControllerComponent = class extends Component
//// constructor
  // @huntTarget:string - what this AI controller should attack. Available values: TARGET, PLAYER, ENEMYFIRST, ENEMYLAST
  // @moveSpeed:number - movement speed
  // @maxObstacklesBeforeFire:int - number of colliders through which controller start shooting
  // @prefPlayerNumber:int<0,2> - player number that this AI controller will hunt. 0 means player will be selected at random
  constructor = function(huntTarget, moveSpeed, maxObstacklesBeforeFire, prefPlayerNumber = 0)
    super()
    
    // current state. Available: WAIT, IDLE, MOVE, ATTACK
    this.State = "IDLE"
    
    // hunt target for this AI controller. Can go after Target or after Player. Available values: TARGET, PLAYER, ENEMYFIRST, ENEMYLAST
    // ENEMYFIRST and ENEMYLAST are special hunt targets assigned to Player entities during demo mode. They alwasy hunt first and last enemy in the list
    this.HuntTarget = huntTarget
    
    // number of player this controller will hunt.
    this.PrefPlayerNumber = prefPlayerNumber
    if this.PrefPlayerNumber == 0 then 
      if Game.Player2 != 0 then
        this.PrefPlayerNumber = random.nextInt(2) + 1
      else
        this.PrefPlayerNumber = 1
      end
    end
    
    // number of obstackles before AI controller will fire at target
    // this is compared to result of Trace to check how many colliders on line of fire this AI should ignore
    // Must be set to 2 or more - MapManager adds bunker around the Target, so it's almost never that the target is not behind the cover
    this.MaxObstacklesBeforeFire = maxObstacklesBeforeFire
    
    // move destination - AI will move here if in "move" state
    this.MoveDestination = 0
    // speed with which AI moves
    this.MoveSpeed = moveSpeed
    
    // ref to Entity that is an attack target. If equal to 0 then there's no attack target selected
    this.AttackTarget = 0
  end

//// Update - Update component
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    // State Machine update
    
    // IDLE state - AI does nothing. This is the spot where decision on next action is taken
    if State == "IDLE" then
      local transform = Owner.Transform
      
      local player1Pos = Game.Player1.Transform.Position
      local player2Pos = 0
      if Game.Player2 != 0 then player2Pos = Game.Player2.Transform.Position end
      
      local p1TraceLength = 1000
      local p2TraceLength = 1000
      
      // AI decision priority list
      // 0. if HuntTarget == ENEMYFIRST or ENEMYLAST then it's a demo mode and should target enemies
      // 1. attack player without cover
      // 2. attack hunt target through cover
      // 3. move to hunt target
      
      // ###### DEMO MODE ####################################################################################
      // handle special case of demo mode
      // this is very buggy and francly, quite pointless
      if HuntTarget == "ENEMYFIRST" or HuntTarget == "ENEMYLAST" then
        local enemy = 0
        if Game.Ai.Enemies.length > 0 then
          if HuntTarget == "ENEMYFIRST" then enemy = Game.Ai.Enemies[0] end
          if HuntTarget == "ENEMYLAST" then enemy = Game.Ai.Enemies[Game.Ai.Enemies.length - 1] end
        end
        if enemy == 0 then return 0 end // premature return, as ther's no enemy AI to attack
        local enemyPos = enemy.Transform.Position
        local enemyTraceLen = Game.Physics.Trace(transform.Position, enemyPos).length
        if enemyTraceLen <= 2 then
          AttackTarget = enemy
          State = "ATTACK"
        else
          // can't attack. Move to enemy
          local navGridX = floor((transform.Position.X + 160) / Game.Map.CurrentMap.block_width)
          local navGridY = floor((transform.Position.Y + 84) / Game.Map.CurrentMap.block_height)
          local nextStep = Game.Ai.GetNextStepToEnemy(enemy, navGridX, navGridY)
          if nextStep != 0 or nextStep != 1 then
            // translate to world coords
            local x = nextStep.X * Game.Map.CurrentMap.block_width - 160 + 8
            local y = nextStep.Y * Game.Map.CurrentMap.block_height - 84 + 8
            
            MoveDestination = new Vector2D(x, y)
            // check if MoveDestination is very far - this can happen sometimes XD
            if transform.Position.Subtract(MoveDestination).GetLength() > 32 then return 0 end
            State = "MOVE"
          end
        end
        return 0 // when in demo mode don't perform any standard AI logic
      end
      // ###### DEMO MODE END ################################################################################
      
      // Attack preffered player if not behind cover
      AttackTarget = 0
      if player2Pos == 0 then // only Player 1 exists / single player game
        p1TraceLength = Game.Physics.Trace(transform.Position, player1Pos).length
        // 2 colliders are collider of the player and collider of the AI itself. There's no other colliders between them
        if p1TraceLength <= 2 then AttackTarget = Game.Player1 end
      else // Player 2 exists / multiplayer game
        // in multiplayer each AI need to check if any of the players are out of cover
        p1TraceLength = Game.Physics.Trace(transform.Position, player1Pos).length
        p2TraceLength = Game.Physics.Trace(transform.Position, player2Pos).length
        
        if PrefPlayerNumber == 1 then // preffering attack Player 1
          if p1TraceLength <= 2 then AttackTarget = Game.Player1
          elsif p2TraceLength <= 2 then AttackTarget = Game.Player2 end
        else // preffering attack Player 2
          if p2TraceLength <= 2 then AttackTarget = Game.Player2
          elsif p1TraceLength <= 2 then AttackTarget = Game.Player1 end
        end
      end
      
      // if AttackTarget is set then a player is out of cover and should be attacked
      if AttackTarget != 0 then
        State = "ATTACK"
      else
        // attack hunt target through cover
        if HuntTarget == "TARGET" then
          // check if target is within allowed number of obstacles to shoot
          local targetPos = Game.Target.Transform.Position
          local targetTraceLength = Game.Physics.TraceAiToTarget(transform.Position, targetPos).length
          if targetTraceLength <= MaxObstacklesBeforeFire then
            AttackTarget = Game.Target
          end
        else // if hunt target is PLAYER
          // check if player is within allowed number of obstacles to shoot
          if PrefPlayerNumber == 1 then // pref player number is 1
            if p1TraceLength <= MaxObstacklesBeforeFire then
              AttackTarget = Game.Player1
            end
          else // pref player number is 2
            if p2TraceLength <= MaxObstacklesBeforeFire then
              AttackTarget = Game.Player2
            end
          end
        end
        
        // if AttackTarget is set then Target or preffered Player is within allowed number of obstacles to attack
        if AttackTarget != 0 then
          State = "ATTACK"
        else 
          // otherwise - move closer to target
          // translate current position into NavGrid coords
          local navGridX = floor((transform.Position.X + 160) / Game.Map.CurrentMap.block_width)
          local navGridY = floor((transform.Position.Y + 84) / Game.Map.CurrentMap.block_height)
          
          // figure out next step on the path, depending if AI is hunting Target or Players
          local nextStep = 0
          if HuntTarget == "TARGET" then
            nextStep = Game.Ai.GetNextStepToTarget(navGridX, navGridY)
          elsif HuntTarget == "PLAYER" then
            if PrefPlayerNumber == 1 then
              nextStep = Game.Ai.GetNextStepToPlayer1(navGridX, navGridY)
            else
              nextStep = Game.Ai.GetNextStepToPlayer2(navGridX, navGridY)
            end
          end
          if nextStep != 0 then
            // translate to world coords
            local x = nextStep.X * Game.Map.CurrentMap.block_width - 160 + 8
            local y = nextStep.Y * Game.Map.CurrentMap.block_height - 84 + 8
            
            MoveDestination = new Vector2D(x, y)
            State = "MOVE"
          else
            // no next step on the path to target
            if HuntTarget == "PLAYER" then
              if PrefPlayerNumber == 1 then
                Game.Ai.BuildVectorFieldToPlayer1()
              else
                Game.Ai.BuildVectorFieldToPlayer2()
              end
            end
          end
        end
      end
    end
    
    // MOVE state - move closer to hunt target
    if State == "MOVE" then
      local transform = Owner.Transform
      local movement = MoveDestination.Subtract(transform.Position)
      if movement.GetLength() > 0.3 then // 0.3 is an trial-and-error value that makes AI not cut corners and stop "close enough" to middle of the cell
        //if HuntTarget == "ENEMYFIRST" then print("moveLen=" + movement.GetLength()) end
        transform.IsMoving = true
        
        // normalize movement vector for corect diagonal speed
        normalized = movement.GetNormalized()
        
        transform.MovementDirection = normalized
        // apply movement to entity's transform
        transform.Position.X += normalized.X * MoveSpeed
        transform.Position.Y += normalized.Y * MoveSpeed
        transform.Rotation = normalized.ToAngle()
      else
        // if length to target is small enough, stop and go back to IDLE state
        transform.IsMoving = false
        State = "IDLE"
      end
    end
    
    // ATTACK state - attack entity referenced in AttackTarget
    if State == "ATTACK" then
      local attack = Owner.GetComponent(AttackComponent)
      if attack.CanAttack() then // CanAttack() just tracks weapon cooldown
        attack.AttackTarget(AttackTarget)
        State = "WAIT" // wait for weapon cooldown to pass before next action
      end
    end
    
    // WAIT state
    if State == "WAIT" then
      local attack = Owner.GetComponent(AttackComponent)
      if attack.CanAttack() then
        State = "IDLE"
      end
    end
  end
end