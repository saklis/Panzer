// Handles logic of drawing UI

UiManager = class
//// constructor
  constructor = function()
  end
  
//// draw
  Draw = function()
    screen.setFont("Romulus") // font loaded in MenuManager
    
    // player 1
    screen.drawText("Player 1", -145, -96, 8, "rgb(93,146,142)")
    // player 1 health
    local player1Health = Game.Player1.GetComponent(HealthComponent).Health
    if player1Health > 0 then screen.drawSprite("heart", -120, -96, 8, 8) end
    if player1Health >= 25 then screen.drawSprite("heart", -111, -96, 8, 8) end
    if player1Health >= 50 then screen.drawSprite("heart", -102, -96, 8, 8) end
    if player1Health >= 75 then screen.drawSprite("heart", -93, -96, 8, 8) end
    if player1Health == 100 then screen.drawSprite("heart", -84, -96, 8, 8) end
    // player 1 kills
    screen.drawSprite("tank_icon", -70, -96, 8, 8)
    screen.drawText("x" + Game.Player1Kills, -58, -96, 8, "rgb(255,255,255)") // number
    
    if Game.Player2 != 0 then
      // player 2
      screen.drawText("Player 2", 145, -96, 8, "rgb(93,109,146)")
      
      // player 2 health
      local player2Health = Game.Player2.GetComponent(HealthComponent).Health
      if player2Health > 0 then screen.drawSprite("heart", 120, -96, 8, 8) end
      if player2Health >= 25 then screen.drawSprite("heart", 111, -96, 8, 8) end
      if player2Health >= 50 then screen.drawSprite("heart", 102, -96, 8, 8) end
      if player2Health >= 75 then screen.drawSprite("heart", 93, -96, 8, 8) end
      if player2Health == 100 then screen.drawSprite("heart", 84, -96, 8, 8) end
      // player 2 kills
      screen.drawSprite("tank_icon", 60, -96, 8, 8)
      screen.drawText("x" + Game.Player2Kills, 72, -96, 8, "rgb(255,255,255)") // number
    end
    
    // enemies left
    screen.drawText("Enemies left: " + (Game.Ai.EnemiesPool + Game.Ai.Enemies.length), 0, -96, 8, "rgb(255,85,85)")
  end
end