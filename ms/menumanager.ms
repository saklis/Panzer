// Handles main menu. Selection of number of players and quitting the game

MenuManager = class
//// constructor
  constructor = function()
    
    // which menu is currently dispplayed. Allowed values: MAINMENU, SUPPORT, CREDITS, INTERMISSION, PAUSEMENU
    this.CurrentMenu = "MAINMENU"
    
    // tracks which option is selected
    this.SelectedOption = 1
    
    // holds info if previous level was lost or won by player
    // Allowed values: PLAYERWON, PLAYERLOST
    // Set inGameFinished() in main.ms. If it's equal to 0, then no levels were played yet (intermission before 1st level)
    PreviousLevelResult = 0
    
    // load required fonts
    screen.loadFont("Edunline")
    screen.loadFont("RetroGaming")
    screen.loadFont("Pixolde")
    screen.loadFont("Pixellari")
    screen.loadFont("PressStart2P")
    screen.loadFont("Romulus") // font used in UiManager
    
    // credits page variables
    CreditsLineHeight = 10
    CreditsScroller = 0
  end
  
//// Init - Initialize Main Menu
  Init = function()
  end
  
//// Update - Update Main Menu
  // @deltaTime:number - amount of time that passed since last update
  Update = function(deltaTime)
    if CurrentMenu == "CREDITS" then 
      CreditsScroller += 0.2 
      if CreditsScroller >= 640 then // 640 is a value for Scroller to pgo pass all lines in credits. Figured out by trial-and-error
        AcceptSelectedOption() // auto-close credits page after it reach time
      end
    end
    
    if Input.Player1.DownBegin then
      if CurrentMenu == "MAINMENU" then
        SelectedOption = Clamp(SelectedOption + 1, 1, 4)
      end
      if CurrentMenu == "PAUSEMENU" then
        SelectedOption = Clamp(SelectedOption + 1, 1, 2)
      end
    end
    if Input.Player1.UpBegin then
      if CurrentMenu == "MAINMENU" then
        SelectedOption = Clamp(SelectedOption - 1, 1, 4)
      end
      if CurrentMenu == "PAUSEMENU" then
        SelectedOption = Clamp(SelectedOption - 1, 1, 2)
      end
    end
    if Input.Player1.FireBegin then
      AcceptSelectedOption()
    end
  end
  
//// Draw - Draw Main Menu
  Draw = function()
    // draw Main Menu or Support page
    if CurrentMenu == "MAINMENU" then
      DrawMainMenu()
    end
    if CurrentMenu == "SUPPORT" then
      DrawSupportPage()
    end
    if CurrentMenu == "CREDITS" then
      DrawCreditsPage()
    end
    if CurrentMenu == "INTERMISSION" then
      DrawIntermission()
    end
    if CurrentMenu == "PAUSEMENU" then
      DrawPauseMenu()
    end
  end
  
//// DrawMainMenu - draws main menu
  DrawMainMenu = function()
    // draw background
    screen.drawMap("bg_mainmenu", 0, 0, 320, 200)
    
    // title
    screen.setFont("Edunline")
    screen.drawTextOutline("Panzer!", 0, 49, 40, "rgb(255,0,0)")
    screen.drawText("Panzer!", 0, 50, 40, "rgb(255,255,255)")
    
    // buttons
    // start game
    screen.setFont("RetroGaming")
    screen.drawText("Start campaign", 0, -15, 10, "rgb(255,255,255)")
    if Input.Player2 == 0 then
      screen.drawText("1 Player", 0, -30, 7,"rgb(150,150,150)")
    else
      screen.drawText("2 Players", 0, -30, 7,"rgb(150,150,150)")
    end
    
    screen.drawText("Support", 0, -55, 10, "rgb(255,255,255)")
    screen.drawText("Credits", 0, -70, 10, "rgb(255,255,255)")
    screen.drawText("Quit", 0, -85, 10, "rgb(255,255,255)")
    
    // draw selection arrow
    local cursorPosY = 0
    if SelectedOption == 1 then cursorPosY = -15 end
    if SelectedOption == 2 then cursorPosY = -55 end
    if SelectedOption == 3 then cursorPosY = -70 end
    if SelectedOption == 4 then cursorPosY = -85 end
    screen.drawSprite("cursor", -85, cursorPosY, 40, 20)
  end
  
//// DrawSupportPage - draws support page
  DrawSupportPage = function()
    screen.drawMap("bg_intermission", 0, 0, 320, 200)
    
    // title
    screen.setFont("Edunline")
    screen.drawTextOutline("Panzer!", 0, 77, 40, "rgb(255,0,0)")
    screen.drawText("Panzer!", 0, 78, 40, "rgb(255,255,255)")
    
    screen.setFont("RetroGaming")
    screen.drawText("You think PANZER! is cool?", 0, 30, 8, "rgb(255,255,255)")
    
    screen.setFont("Pixolde")
    screen.drawText("Watch post mortem dev log on YouTube", 0, 5, 10, "rgb(255,255,255)")
    screen.drawText("youtu.be/WWmciThb680", 0, -10, 12, "rgb(255,255,255)")
    
    screen.drawText("- or -", 0, -30, 10, "rgb(255,255,255)")
    
    screen.drawText("Support PANZER! on itch.io", 0, -50, 10, "rgb(255,255,255)")
    screen.drawText("funthingshappen.itch.io/panzer", 0, -64, 12, "rgb(255,255,255)")
    
    // shoot to return
    screen.setFont("RetroGaming")
    screen.drawTextOutline("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,0,0)")
    screen.drawText("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,255,255)")
  end
  
//// DrawCreditsPage - draws credits page
  DrawCreditsPage = function()
    screen.drawMap("bg_intermission", 0, 0, 320, 200)
    
    // title
    screen.setFont("Edunline")
    screen.drawTextOutline("Panzer!", 0, 77, 40, "rgb(255,0,0)")
    screen.drawText("Panzer!", 0, 78, 40, "rgb(255,255,255)")
    
    local credits = [
      "*DESIGN AND CODING",
      " Sebastian [Fun Things Happen]",
      " ",
      " ",
      "*POWERED BY microStudio",
      " created by Gilles Pommereuil",
      " ",
      " ",
      " ",
      ">ART",
      " ",
      "*2D Battle Tanks",
      " by CraftPix.net 2D Game Assets",
      " ",
      "*140 tiles of grassland and mines",
      " by Anokolisa",
      " ",
      "*2D Explosion Animations",
      " by Sinestesia",
      " ",
      "*2D Explosion Animations #2",
      " by Sinestesia",
      " ",
      "*Poof Effect Spritesheet",
      " by jellyfizh",
      " ",
      "*Fireworks Effect Spritesheet",
      " by jellyfizh",
      " ",
      "*Animated Ocean Water Tile",
      " by POKOMOKO",
      " ",
      "*Onscreen Controls",
      " by Kenney",
      " ",
      "*Generic Items",
      " by Kenney",
      " ",
      " ",
      " ",
      ">SOUND",
      " ",
      "*Q009's weapon sounds",
      " by Q009",
      " ",
      "*8-Bit Sound Effects Library",
      " by Little Robot Sound Factory",
      " ",
      " ",
      " ",
      ">MUSIC",
      " ",
      "*5 Chiptunes (Action)",
      " by Juhani Junkala / SubspaceAudio"]
    
    local yMax = 30
    local yMin = -70
    
    for i = 0 to credits.length - 1
      local y = yMin + CreditsScroller - i * CreditsLineHeight
      if y >= yMin and y <= yMax then
        local text = credits[i].substring(1, credits[i].length)
        local fontSize = 7
        if credits[i].startsWith(">") then
          screen.setFont("PressStart2P")
          fontSize = 11
        elsif credits[i].startsWith("*") then 
          screen.setFont("Pixellari")
          fontSize = 8
        else 
          screen.setFont("Pixolde") 
          fontSize = 7
        end
        screen.drawText(text, 0, y, fontSize, "rgb(255,255,255)")
      end
    end
    
    // shoot to return
    screen.setFont("RetroGaming")
    screen.drawTextOutline("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,0,0)")
    screen.drawText("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,255,255)")
  end
  
//// DrawIntermission - draw intemission page
  DrawIntermission = function()
    // GameLevelIndex is an index of "current" level in DB
    // GameLevelIndex + 1 is an index of "next" level in DB
    // while inside screen.drawText() method additional +1 need to be added, since for player, Levels are 1-based
    // GameLevelIndex + 1 while in drawText() is "current" level
    // GameLevelIndex + 2 while in drawText() is "next" level
    
    screen.drawMap("bg_intermission", 0, 0, 320, 200)
    
    // title
    if PreviousLevelResult == 0 then
      screen.setFont("Edunline")
      screen.drawTextOutline("Campaign", 0, 77, 40, "rgb(255,0,0)")
      screen.drawText("Campaign", 0, 78, 40, "rgb(255,255,255)")
      if Input.Player2 != 0 then
        screen.drawText("2 PLAYERS", 0, 40, 20, "rgb(255,255,255)")
      else
        screen.drawText("1 PLAYER", 0, 40, 20, "rgb(255,255,255)")
      end
    elsif PreviousLevelResult == "PLAYERWON" then
      screen.setFont("Edunline")
      screen.drawTextOutline("Congratulations!", 0, 77, 25, "rgb(255,0,0)")
      screen.drawText("Congratulations!", 0, 78, 25, "rgb(255,255,255)")
      screen.drawText("You won LEVEL " + (GameLevelIndex + 1), 0, 40, 20, "rgb(255,255,255)")
    elsif PreviousLevelResult == "PLAYERLOST" then
      screen.setFont("Edunline")
      screen.drawTextOutline("You lost...", 0, 77, 25, "rgb(255,0,0)")
      screen.drawText("You lost...", 0, 78, 25, "rgb(255,255,255)")
      screen.drawText("GAME OVER", 0, 40, 20, "rgb(255,255,255)")
    end
    
    local nextLevelExists = (GameLevelIndex + 1) < Database.Levels.length
    
    if (PreviousLevelResult == 0 or PreviousLevelResult == "PLAYERWON") and nextLevelExists then
      screen.setFont("Pixolde")
      screen.drawText("Next level: LEVEL " + (GameLevelIndex + 2), 0, -20, 20, "rgb(255,255,255)")
      screen.drawText("Current score: " + GameScore, 0, -40, 13, "rgb(255,255,255)")
      screen.drawText("Total PLAYER 1 kills: " + GamePlayer1Kills, 0, -51, 8, "rgb(255,255,255)")
      if Game.Player2 != 0 then
        screen.drawText("Total PLAYER 2 kills: " + GamePlayer2Kills, 0, -60, 8, "rgb(255,255,255)")
      end
      
      // shoot to begin
      screen.setFont("RetroGaming")
      screen.drawTextOutline("Press SHOOT to begin LEVEL " + (GameLevelIndex + 2), 0, -90, 9, "rgb(255,0,0)")
      screen.drawText("Press SHOOT to begin LEVEL " + (GameLevelIndex + 2), 0, -90, 9, "rgb(255,255,255)")
    elsif nextLevelExists == false or PreviousLevelResult == "PLAYERLOST" then
      screen.setFont("Pixolde")
      screen.drawText("End of campaign", 0, -20, 20, "rgb(255,255,255)")
      screen.drawText("Final score: " + GameScore, 0, -40, 13, "rgb(255,255,255)")
      screen.drawText("Total PLAYER 1 kills: " + GamePlayer1Kills, 0, -51, 8, "rgb(255,255,255)")
      if Game.Player2 != 0 then
        screen.drawText("Total PLAYER 2 kills: " + GamePlayer2Kills, 0, -60, 8, "rgb(255,255,255)")
      end
      
      // shoot to begin
      screen.setFont("RetroGaming")
      screen.drawTextOutline("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,0,0)")
      screen.drawText("Press SHOOT to return to MAIN MENU", 0, -90, 9, "rgb(255,255,255)")
    end
  end
  
//// DrawPauseMenu - draw pause menu
  DrawPauseMenu = function()
    // background
    screen.setAlpha(0.5)
    screen.fillRect(0, 0, 140, 80,"rgb(0,0,0)")
    screen.setAlpha(1)
    screen.drawMap("bg_pause", 0, 0, 320, 200)
    
    // title
    screen.setFont("Edunline")
    screen.drawTextOutline("Pause", 0, 34, 15, "rgb(255,0,0)")
    screen.drawText("Pause", 0, 35, 15, "rgb(255,255,255)")
    
    // options
    screen.setFont("RetroGaming")
    screen.drawText("Continue", 0, -5, 10, "rgb(255,255,255)")
    screen.drawText("Quit", 0, -25, 10, "rgb(255,255,255)")
    
    // draw selection arrow
    local cursorPosY = 0
    if SelectedOption == 1 then cursorPosY = -5 end
    if SelectedOption == 2 then cursorPosY = -25 end
    screen.drawSprite("cursor", -60, cursorPosY, 40, 20)
  end
  
//// AcceptSelectedOption - accept selection and performs required actions
  AcceptSelectedOption = function()
    // hack for touch controls.
    // Forces Fire to be "held" after each use of touch to accept option in menu
    // this prevents Fire Press from being set multiple times in a row and causing skipping of manu options
    if Input.Touch != 0 then 
      Input.Touch.Fire = true
      Input.Touch.FireBegin = false
    else
      Input.Player1.Reset()
    end
    
    if CurrentMenu == "MAINMENU" then
      if SelectedOption == 1 then
        BeginNewCampaign() // global function defined in main.ms
      end
      if SelectedOption == 2 then
        CurrentMenu = "SUPPORT"
        SelectedOption = 1
      end
      if SelectedOption == 3 then
        CurrentMenu = "CREDITS"
        SelectedOption = 1
        CreditsScroller = 0
      end
      if SelectedOption == 4 then
        system.exit()
      end
    elsif CurrentMenu == "SUPPORT" or CurrentMenu == "CREDITS" then
      CurrentMenu = "MAINMENU"
      SelectedOption = 1
    elsif CurrentMenu == "INTERMISSION" then
      local nextLevelExists = (GameLevelIndex + 1) < Database.Levels.length
      if nextLevelExists and PreviousLevelResult != "PLAYERLOST" then
        NextLevel()
      else
        GoToMainMenu()
        SelectedOption = 1
      end
    elsif CurrentMenu == "PAUSEMENU" then
      if SelectedOption == 1 then
        PauseGame() // unpause game. Global function defined in main.ms
      elsif SelectedOption == 2 then
        GoToMainMenu()
        SelectedOption = 1
      end
    end
  end
end